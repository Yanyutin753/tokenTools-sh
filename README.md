# tokenTools-sh

## 使用方法

### 一键部署PandoraNext和tokensTool(最强推荐)

#### 将直接拉取最新版本的PandoraNext和tokensTool

```
# 安装git
(Ubuntu)
sudo apt update
sudo apt install git

（如Fedora、CentOS等）
sudo yum update
sudo yum install git

# 国内服务器
cd / && git clone https://gitee.com/yangyangEN/tokenTools-sh.git

# 国外服务器
cd / && git clone https://github.com/Yanyutin753/tokenTools-sh.git

# 运行脚本
cd /tokenTools-sh && sudo sh install.sh

# 一键更新pandoraNext和tokensTool服务
cd /tokenTools-sh && sudo sh update.sh

# 更新update.sh或者install.sh

# 国内
sudo rm -rf /tokenTools-sh && cd / && git clone https://gitee.com/yangyangEN/tokenTools-sh.git
# 国外
sudo rm -rf /tokenTools-sh && cd / && git clone https://github.com/Yanyutin753/tokenTools-sh.git
```
