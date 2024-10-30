# docker buildx build -f dockerfiles/DockerFile.app --platform linux/amd64 -t test:test --load .
# docker buildx build -f docker/app.DeckerFile --platform linux/amd64 -t test:test .

# 引入配置文件
source "$(dirname "$0")/var.sh"

# 構建app新映像
docker buildx build -f scripts/docker/app.DeckerFile --platform linux/amd64 -t ${IMAGE_NAME}:${TAG} --load .

# 如果構建成功，清理懸掛映像
if [ $? -eq 0 ]; then
    echo "建立成功。 清理懸空映像..."
    
    # 刪除所有懸掛映像
    docker image prune -f
    
    echo "消除了懸空映像。"
else
    echo "構建失敗。 沒有刪除任何映像。"
fi