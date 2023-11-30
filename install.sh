#!/bin/bash

# 函数：确认删除目录
confirm_delete() {
    echo "目标目录已存在，是否删除并拉取最新代码？(y/n)"
    read confirm
    if [ "$confirm" == "y" ]; then
        # 检查是否有足够的权限
        if [ ! -w /pandora ]; then
            echo "没有足够的权限删除目录，请检查权限设置。"
            exit 1
        fi

        # 删除目录的操作
        cd / && rm -rf /pandora
    else
        echo "取消操作，退出脚本。"
        exit 1
    fi
}

echo "检查是否已经安装 docker"
if ! command -v docker &> /dev/null; then
    # 安装 Docker
    sudo apt update
    sudo apt-get install docker-ce
    echo "安装 Docker 成功！"
else
    echo "Docker 已经安装，跳过安装步骤。"
fi

echo "检查是否已经安装 docker-compose"
if ! command -v docker-compose &> /dev/null; then
    # 安装 docker-compose
    sudo apt install docker-compose
    echo "安装 docker-compose 成功！"
else
    echo "Docker Compose 已经安装，跳过安装步骤。"
fi

# 设置目标目录
target_dir="/pandora"

# 检查目标目录是否已经存在
if [ -d "$target_dir" ]; then
    confirm_delete
fi

echo "克隆 github 仓库到目标目录并切换到主分支"
git clone https://github.com/Yanyutin753/most-simply-deploy-PandoaraNext.git /pandora
echo "克隆成功"

echo "进入 /pandora 目录"
cd /pandora

# 运行 Docker Compose 启动命令
docker-compose up -d
echo "启动成功，请确保开启 8081 端口和 8181 端口"
