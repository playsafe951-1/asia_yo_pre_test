#!/bin/bash

# 引入配置文件
source "$(dirname "$0")/var.sh"

# 檢查容器是否存在
if [ "$(docker ps -aq -f name=^/${CONTAINER_NAME}$)" ]; then
    echo "容器 $CONTAINER_NAME 存在。正在停止並移除..."
    
    # 停止容器
    docker stop $CONTAINER_NAME
    
    # 移除容器
    docker rm $CONTAINER_NAME
    
    echo "容器 $CONTAINER_NAME 已被移除。"
fi

# 運行新的容器
echo "正在啟動新容器 $CONTAINER_NAME..."
docker run -d \
    --name $CONTAINER_NAME \
    -v "$CONFIG_PATH:/config" \
    -v "$STORAGE_PATH:/var/www/html/storage" \
    -p $PORT \
    -e UID=1000 -e GID=1000 \
    $IMAGE_NAME:$TAG

# 檢查容器是否成功啟動
if [ "$(docker ps -q -f name=^/${CONTAINER_NAME}$)" ]; then
    echo "容器 $CONTAINER_NAME 現在正在運行。"
else
    echo "啟動容器 $CONTAINER_NAME 失敗。請檢查日誌。"
fi

# 顯示容器日誌
echo "顯示容器日誌："
docker logs $CONTAINER_NAME