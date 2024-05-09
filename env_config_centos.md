# zsh
## 1. 安装zsh
`sudo yum install zsh` 
## 2. 安装Oh My Zsh
``` sh
sh -c "$(curl -fsSL https://gitcode.net/apull/ohmyzsh/-/raw/master/tools/install_gitcode.sh)"
```
## 3. 安装zsh-autosuggestions
### 切换至插件目录
``` sh
cd $ZSH_CUSTOM/plugins
```
### clone仓库
``` sh
git clone https://github.com/zsh-users/zsh-autosuggestions.git
```
### 打开配置文件
``` sh
vim ~/.zshrc
```
### 在`plugins=(git)`下面输入以下内容
``` sh
plugins=(git zsh-autosuggestions)
plugins=(z)
```
### 刷新配置文件
``` sh
source ~/.zshrc
```

# git
## 1. 安装
``` sh
yum install -y git
```
## 2. 配置gitconfig
``` sh
[user]
    email = zhonghang181@163.com
    name = chentao
[alias]
    loga = log --graph --pretty=format:'%Cred%h%Creset -%C(blue)%an%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative
        email = send-email --confirm=always
[core]
    autocrlf = input
    editor = vim
    safecrlf = false
    quotepath = false
[diff]
    tool = vimdiff
    renameLimit = 99999
[pager]
    diff = diff-so-fancy | less --tabs=1,5 -RFX
    show = diff-so-fancy | less --tabs=1,5 -RFX
```
## 3. 安装diff-so-fancy
### 切换到zsh插件目录
``` sh
cd $ZSH_CUSTOM/plugins
```
### 克隆代码 
``` sh
git clone https://github.com/so-fancy/diff-so-fancy.git
```
### 打开配置文件
``` sh
vim ~/.zshrc
```
### 在`plugins=(git)`下面输入以下内容
``` sh
plugins=(git diff-so-fancy)
```
### 刷新配置文件
``` sh
source ~/.zshrc
```

# skynet
## 1. 安装关联工具
``` sh
yum -y install gcc automake autoconf libtool make readline-devel openssl-devel wget
```
## 2. 编译zlib
``` sh
cd skynet/3rd/zlib/
./configure
make
```
## 3. 配置SSL
### 打开skynet/Makefile修改
``` sh
TLS_MODULE=ltls
TLS_LIB=
TLS_INC=
```
## 4. 安装mysql

### 下载mysql安装包
``` sh
wget https://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm
```
### 安装mysql
``` sh
rpm -ivh mysql57-community-release-el7-8.noarch.rpm
```
### 进入目录
``` sh
cd /etc/yum.repos.d/
```
### 更新密钥
``` sh
rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
```
### 安装服务
``` sh
yum -y install mysql-server
```
### 启动服务
``` sh
systemctl start mysqld
```
### 初始密码为空
``` sh
mysql -u root -p
```
### 更改密码
``` sh
ALTER USER 'root'@'localhost' IDENTIFIED BY 'admin'; 
```
## 5.更新gcc版本(可选)
``` sh
yum -y install centos-release-scl
yum -y install devtoolset-9
scl enable devtoolset-9 zsh
gcc -v
```

# chess
## 1. 导入数据库
``` sh 
mysql -u root -p < chess.sql
```

# nginx
## 1. 安装
``` sh
yum install -y nginx
```