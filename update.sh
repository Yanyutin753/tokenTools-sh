#!/bin/sh

echo "检查 /pandora 路径是否存在"
if [ -d "/pandora" ]; then
    echo "开始更新 Pandora 服务..."

    # 切换到 /pandora 目录
    cd /pandora || exit

    # 停止 tokensTool 和 PandoraNext 服务
    docker-compose down

    echo "拉取最新的镜像"
    docker-compose pull

    # 重新构建并启动所有服务
    docker-compose up -d --build
    
    running_images=$(docker ps -a --format "{{.Image}}")
    
    # 获取所有镜像
    all_images=$(docker images -a --format "{{.ID}} {{.Repository}}")
    
    # 初始化一个变量来跟踪是否所有的镜像都被成功删除
    all_images_removed=true
    
    # 遍历所有的镜像
    echo "$all_images" | while IFS= read -r image; do
        # 提取镜像ID和镜像名
        image_id=$(echo "$image" | cut -d' ' -f1)
        image_name=$(echo "$image" | cut -d' ' -f2)
    
        # 检查这个镜像是否是 PandoraNext 或 tokensTool
        case "$image_name" in
            PandoraNext|tokensTool)
                # 检查这个镜像是否正在运行
                case "$running_images" in
                    *"$image_name"*)
                        ;; # Image is running, do nothing
                    *)
                        # 如果这个镜像没有正在运行，那么删除它
                        docker rmi -f "$image_id"
                        
                        # 如果删除镜像的命令失败，那么设置 all_images_removed 为 false
                        if [ $? -ne 0 ]; then
                            all_images_removed=false
                        fi
                        ;;
                esac
                ;;
        esac
    done

    # 等待所有的后台任务都完成
    wait

    # 如果所有的镜像都被成功删除，那么输出 "所有镜像删除成功"
    if $all_images_removed; then
        echo "旧镜像删除成功。"
    else
        echo "有些镜像没有被成功删除。"
    fi
else
    echo "没有 /pandora 路径，请先一键部署之后才能一键更新。"
fi
