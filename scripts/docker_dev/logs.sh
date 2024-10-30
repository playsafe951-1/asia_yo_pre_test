#!/bin/bash

# 引入配置文件
source "$(dirname "$0")/var.sh"

# 創建關聯數組來存儲容器名稱和描述
declare -A containers
containers["$CONTAINER_NAME"]="Web 應用容器"

# 獲取運行中的容器
running_containers=()
for container in "${!containers[@]}"; do
    if docker ps -q -f name="^/${container}$" > /dev/null; then
        running_containers+=("$container")
    fi
done

# 檢查是否有運行中的容器
if [ ${#running_containers[@]} -eq 0 ]; then
    echo "沒有運行中的指定容器。"
    exit 1
fi

# 顯示容器列表
echo "請選擇要連接的容器:"
for i in "${!running_containers[@]}"; do
    container=${running_containers[$i]}
    echo "$((i+1)). ${containers[$container]} ($container)"
done

# 讀取用戶輸入
read -p "輸入選項數字: " choice

# 驗證輸入
if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt ${#running_containers[@]} ]; then
    echo "無效的選擇。"
    exit 1
fi

# 獲取選中的容器名稱
selected_container=${running_containers[$((choice-1))]}

# 連接到選中的容器
echo "正在連接到容器: $selected_container"
docker logs "$selected_container"

# 如果 exec 命令失敗，顯示錯誤信息
if [ $? -ne 0 ]; then
    echo "連接失敗。請確保容器正在運行且有 /bin/bash 可用。"
fi