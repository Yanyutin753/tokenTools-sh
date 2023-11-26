echo "检查是否已经安装 docker"
if ! command -v docker &> /dev/null
then
    # 安装 Docker
    sudo apt update
    sudo apt-get install docker-ce
    echo "安装Docker成功！"
else
    echo "Docker 已经安装，跳过安装步骤。"
fi

echo "检查是否已经安装 docker-compose"
if ! command -v docker-compose &> /dev/null
then
    # 安装 docker-compose
    sudo apt install docker-compose
    echo "安装docker-compose成功！"
else
    echo "Docker Compose 已经安装，跳过安装步骤。"
fi

# 切换到根目录
cd /

# 设置目标目录
target_dir="/pandora"

# 检查目标目录是否已经存在
if [ -d "$target_dir" ]; then
    echo "目标目录已存在，将进行删除全部目录并拉取最新代码操作。"
    # 切换到其他目录，然后删除目标目录下所有内容
    cd / && rm -rf "$target_dir"
fi

echo "克隆 github 仓库到目标目录并切换到主分支"
git clone https://github.com/Yanyutin753/most-simply-deploy-PandoaraNext.git /pandora
echo "克隆成功"

echo "进入 /pandora 目录"
cd /pandora

# 运行 Docker Compose 启动命令
docker-compose up -d
echo "启动成功 确保开启8081端口和8181端口"
