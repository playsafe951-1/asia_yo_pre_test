####################################################################################################################

# 使用 composer 容器，並把此階段命名為 vendor
FROM composer:latest AS vendor

# 設定容器內的工作目錄，接下來所有要執行的指令，預設都會在這個目錄底下進行
WORKDIR /var/www/html

# 將專案內的 'composer.json' 與 'composer.lock' 檔案複製到容器內的 `/var/www/html` 資料夾中
# 因為上一步已經設定工作目錄為 `/var/www/html`，因此這裡的 `./` (意即當前目錄)就會是 `/var/www/html`
COPY composer* ./

# 使用 composer 安裝正式環境運行時所需要的套件
# 這裡有使用 `--no-dev` 避免安裝開發時用的套件
RUN composer install \
    --no-dev \
    --no-interaction \
    --prefer-dist \
    --ignore-platform-reqs \
    --optimize-autoloader \
    --apcu-autoloader \
    --ansi \
    --no-scripts \
    --audit

####################################################################################################################    

# 使用 node 容器，並把此階段命名為 assets
FROM node:latest AS assets

# 設定容器內的工作目錄
WORKDIR /var/www/html

# 將全部專案都複製進去
COPY . .

# 使用 npm 安裝前端依賴套件，並打包前端資源
RUN npm install \
    && npm run build

####################################################################################################################

FROM php:8.3-cli-bullseye

USER root
LABEL maintainer="Allen"

ENV ROOT=/var/www/html
WORKDIR $ROOT

SHELL ["/bin/bash", "-exou", "pipefail", "-c"]

# 安全地處理 libc-bin 問題
RUN rm /var/lib/dpkg/info/libc-bin.* && \
    apt-get clean && \
    apt-get update && \
    apt-get install -y libc-bin

# 安裝必要的包和 PHP 擴展
RUN apt-get update && \
    apt-get upgrade -yqq && \
    apt-get install -yqq --no-install-recommends \
    libbrotli-dev libmongoc-dev libssl-dev \
    curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-install pdo_mysql opcache pcntl && \
    pecl install redis swoole && \
    docker-php-ext-enable redis swoole

# 安装 Node.js 和 npm
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs

ARG UID=1000
ARG GID=1000

RUN groupadd --force -g $GID octane && \
    useradd -ms /bin/bash --no-log-init --no-user-group -g $GID -u $UID octane

RUN set -eux; \
	apt-get update; \
	apt-get install -y gosu; \
	rm -rf /var/lib/apt/lists/*; \
# verify that the binary works
	gosu nobody true

# 複製專案文件
COPY . .

RUN npm install

RUN mkdir -p /config && \
    chown -R octane:octane /config

RUN mkdir -p \
    storage/app/public \
    storage/framework/{sessions,views,cache/data} \
    storage/logs \
    bootstrap/cache && \
    chown -R octane:octane \
    bootstrap/cache \
    database && \
    chmod -R ug+rwx storage bootstrap/cache

RUN php artisan storage:link

RUN chown -R octane:octane \
    storage \
    bootstrap/cache \
    public \
    database && \
    chmod -R ug+rwx storage bootstrap/cache

# 複製 PHP 配置文件
COPY deployment/php/php.ini /usr/local/etc/php/conf.d/octane.ini
COPY deployment/php/opcache.ini /usr/local/etc/php/conf.d/opcache.ini

# 設置啟動腳本
COPY deployment/scripts/app-entrypoint.sh deployment/scripts/app-entrypoint.sh
RUN chmod +x deployment/scripts/app-entrypoint.sh

EXPOSE 9000
VOLUME ["/config","/var/www/html/storage"]

# USER octane

ENTRYPOINT ["deployment/scripts/app-entrypoint.sh"]

HEALTHCHECK --start-period=5s --interval=30s --timeout=5s --retries=8 \
    CMD curl --fail localhost:9000 || exit 1
