#!/bin/bash

# 引入配置文件
source "$(dirname "$0")/var.sh"

# 檢查容器是否存在
if [ "$(docker ps -aq -f name=^/${CONTAINER_NAME}$)" ]; then
    echo "容器 $CONTAINER_NAME 存在。正在停止..."
    
    # 停止容器
    docker stop $CONTAINER_NAME
    
    echo "容器 $CONTAINER_NAME 已被停止。"
fi