#!/bin/bash

echo "检查 /pandora 路径是否存在"
if [ -d "/pandora" ]; then
    echo "开始更新 Pandora 服务..."

    # 切换到 /pandora 目录
    cd /pandora

    # 停止并移除所有正在运行的容器
    docker-compose down

    # 拉取最新的镜像
    docker-compose pull

    # 重新构建并启动所有服务
    docker-compose up -d --build

    echo "更新完成。"
else
    echo "没有 /pandora 路径，请先一键部署之后才能一键更新。"
fi
