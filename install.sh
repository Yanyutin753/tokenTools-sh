#!/bin/bash

# 函数：确认删除目录
confirm_delete() {
    echo "目标目录已存在，是否删除并拉取最新代码？(y/n)"
    read confirm
    if [ "$confirm" = "y" ]; then  # 修改了这一行
        # 检查是否有足够的权限
        if [ ! -w /pandora ]; then
            echo "没有足够的权限删除目录，请检查权限设置。"
            exit 1
        fi

        # 删除目录的操作
        cd / && rm -rf /pandora

        # 重新创建目录
        mkdir /pandora
    else
        echo "取消操作，退出脚本。"
        exit 1
    fi
}

echo "检查是否已经安装 bash"
if ! command -v bash &> /dev/null; then
    # 安装 bash
    if command -v apt &> /dev/null; then
        sudo apt update
        sudo apt-get install bash
    elif command -v yum &> /dev/null; then
        sudo yum update
        sudo yum install bash
    else
        echo "不支持的包管理器，无法安装 bash。"
        exit 1
    fi
    echo "安装 bash 成功！"
else
    echo "bash 已经安装，跳过安装步骤。"
fi
echo "检查是否已经安装 docker"
if ! command -v docker &> /dev/null; then
    # 安装 Docker
    if command -v apt &> /dev/null; then
        sudo apt update
        sudo apt-get install docker-ce
    elif command -v yum &> /dev/null; then
        sudo yum update
        sudo yum install docker-ce
    else
        echo "不支持的包管理器，无法安装 Docker。"
        exit 1
    fi
    echo "安装 Docker 成功！"
else
    echo "Docker 已经安装，跳过安装步骤。"
fi

echo "检查是否已经安装 docker-compose"
if ! command -v docker-compose &> /dev/null; then
    # 安装 docker-compose
    if command -v apt &> /dev/null; then
        sudo apt update
        sudo apt install docker-compose
    elif command -v yum &> /dev/null; then
        sudo yum update
        sudo yum install docker-compose
    else
        echo "不支持的包管理器，无法安装 Docker Compose。"
        exit 1
    fi
    # 检查安装是否成功
    if command -v docker-compose &> /dev/null; then
        echo "安装 Docker Compose 成功！"
    else
        echo "安装 Docker Compose 失败，请检查安装过程。"
        exit 1
    fi
else
    echo "Docker Compose 已经安装，跳过安装步骤。"
fi

# 设置目标目录
target_dir="/pandora"

# 检查目标目录是否已经存在
if [ -d "$target_dir" ]; then
    confirm_delete
fi

echo "克隆 gitee 仓库到目标目录并切换到主分支"
git clone https://gitee.com/yangyangEN/most-simply-deploy-PandoaraNext.git /pandora
echo "克隆成功"

echo "进入 /pandora 目录"
cd /pandora

while true; do
    # 提示用户输入新的端口号
    read -p "请输入tokensTool的端口号（默认为8081）: " new_port

    # 如果用户没有输入，使用默认端口号8081
    new_port=${new_port:-8081}

    # 检验端口号是否为一个数字，并且是否在1到65535的范围内
    if [ "$new_port" -ge 1 ] && [ "$new_port" -le 65535 ] && [ "$new_port" -eq "$new_port" ] 2>/dev/null; then
    # 输入合法，退出循环
      break
    else
      echo "错误：端口号无效，请输入一个有效的端口号（1到65535之间）。"
    fi
done


while true; do
    # 提示用户是否需要自定义后缀
    read -p "是否需要自定义后缀? (y/n) " need_suffix
    if [ "$need_suffix" = "y" ]; then
        while true; do
            # 提示用户输入新的后缀
            printf "请输入新的后缀（例如：/tokensTool）: "
            read new_suffix
    
            # 如果用户没有输入，使用默认后缀 '/'
            new_suffix=${new_suffix:-/}
    
            # 检查新的后缀是否以 '/' 开始
            case "$new_suffix" in
                /*) 
                    # 后缀以 '/' 开始，退出内部循环
                    break
                    ;;
                *) 
                    # 后缀不以 '/' 开始，提示用户重新输入
                    printf "错误：后缀应以 '/' 开始，请重新输入。\n"
                    ;;
            esac
        done
        # 后缀已经被替换，退出外部循环
        break
    elif [ "$need_suffix" = "n" ]; then
        new_suffix=/
        break
    else
        printf "错误：无效的输入，请输入 'y' 或 'n'.\n"
    fi
done

# 替换docker-compose.yml文件中的后缀和端口号
sed -i -e "s|--server.servlet.context-path=/|--server.servlet.context-path=${new_suffix}|" -e "s|--server.port=[0-9]\+|--server.port=${new_port}|" docker-compose.yml

# 运行 Docker Compose 启动命令
if docker-compose up -d; then
    echo "Docker Compose 启动成功，请确保开启 ${new_port} 端口和 8181 端口"
    echo "tokensTool启动网址：http://127.0.0.1:${new_port}${new_suffix}"
    echo "初始值userName : root"
    echo "初始值Password : 123456"
else
    echo "Docker Compose 启动失败！请确保正确安装docker和docker compose"
fi
