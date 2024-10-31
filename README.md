# 題目一
select bnb_id,sum(amount) as may_amount from orders where month(created_at) = 5 and currency = 'TWD' group by bnb_id,month(created_at) limit 10;
# 題目二
建立month_created生成列
ALTER TABLE orders ADD COLUMN month_created INT GENERATED ALWAYS AS (MONTH(created_at)) STORED;
增加currency和month_created的複合索引
CREATE INDEX idx_c_m on orders (currency,month_created);

# 實作
策略模式

# docker-compose
```
services:
  asia_yo_pre_test_web:
    container_name: asia_yo_pre_test_test_web
    image: ghcr.io/playsafe951-1/asia_yo_pre_test:latest
    volumes:
     - /home/kurumi/laravel/asia_yo_pre_test/docker_test/config:/config
     - /home/kurumi/laravel/asia_yo_pre_test/docker_test/storage:/var/www/html/storage
    ports:
      - "1000:9000"
    environment:
     - GID=1000
     - UID=1000
```