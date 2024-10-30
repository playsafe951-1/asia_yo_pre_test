#!/usr/bin/env bash
set -e


# 獲取傳入的 UID 和 GID，如果沒有設置則使用默認值
USER_ID=${UID:-1000}
GROUP_ID=${GID:-1000}

usermod -u $USER_ID octane
groupmod -g $GROUP_ID octane

# 檢查 /config/.env 是否存在
if [ ! -f /config/.env ]; then
    echo ".env file not found in /config, copying from example..."
    # 檢查範例 .env 文件是否存在
    if [ -f /var/www/html/example/config/.env ]; then
        cp /var/www/html/example/config/.env /config/.env
        echo "Copied example .env to /config/.env"
    else
        echo "Warning: Example .env file not found in /var/www/html/example/"
        echo "Please ensure a valid .env file is provided."
    fi
else
    echo "Using existing .env file from /config"
fi

# 創建符號連結
ln -sf /config/.env /var/www/html/.env

# 檢查符號連結是否成功創建
if [ -L /var/www/html/.env ] && [ -e /var/www/html/.env ]; then
    echo "Symlink to .env file created successfully"
else
    echo "Warning: Failed to create symlink to .env file"
fi



mkdir -p /var/www/html/storage/framework/{sessions,views,cache/data} \
         /var/www/html/storage/app/public \
         /var/www/html/storage/logs \
         /var/www/html/bootstrap/cache

npm run build
php artisan migrate --force
php artisan optimize:clear
php artisan package:discover --ansi
php artisan config:cache
php artisan route:cache
php artisan view:cache
         
# # 檢查是否有權限更改所有權
if touch /var/www/html/storage/permissions_test && rm /var/www/html/storage/permissions_test; then
    # 如果有權限，設置正確的所有權
    chown -R octane:octane \
        /var/www/html/public \
        /var/www/html/storage \
        /var/www/html/bootstrap/cache \
        /var/www/html/storage/app/public \
        /var/www/html/database
else
    echo "Warning: Unable to change ownership of the storage directory. Skipping..."
fi

# # 設置正確的權限（這通常不需要 root 權限）
chmod -R ug+rwx /var/www/html/storage /var/www/html/bootstrap/cache

gosu octane php artisan octane:start --server=swoole --host=0.0.0.0 --port=9000 --workers=auto --task-workers=auto --max-requests=500