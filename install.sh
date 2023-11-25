#!/bin/bash

# 安装 Docker
sudo apt update
sudo apt-get install docker-ce

# 切换到根目录
cd /

# 安装 docker-compose
sudo apt install docker-compose

# 克隆 GitHub 仓库
git clone https://github.com/Yanyutin753/most-simply-deploy-PandoaraNext.git /pandora


# 进入 /pandora 目录
cd /pandora

# 运行 Docker Compose 启动命令
echo "启动 开启8081端口和8181端口"
docker-compose up -d
