# 基于

[x11vnc/docker-desktop:zh_CN](https://hub.docker.com/r/x11vnc/docker-desktop)原版镜像

# Host配置

- docker
- nvidia-docker2
- host已安装显卡驱

# 使用方法

1. 准备文件夹
    
    common和Porject-X是两个数据卷，功能上完全一致；用法上，common是一个共享数据卷，多个项目的共享空间，可以用来放置数据集、公共代码等，Porject-X项目专用的数据卷，存放项目代码等。
    

```bash
docker_containers
|---common
|---Project-1
   |---x11vnc_desktop.py
|---Project-2
   |---x11vnc_desktop.py
|---Project-3
   |---x11vnc_desktop.py
...
```

2. 创建container。注意，使用此脚本创建多个container，如果多个container共存，必须保持要共存的container为开启状态，否则端口将会被占用
    
    修改PROJECT_NAME="project-1"
    

```bash
cd ~
cd docker_containers
PROJECT_NAME="project-1"
git clone https://github.com/Maxwell-lx/docker-desktop-pytorch.git "$PROJECT_NAME"
cd "$PROJECT_NAME"
python3 x11vnc_desktop.py -v "/home/$USER/docker-containers/common" -V -p
```

3. 一键配置环境。在打开的默认终端中

```bash
bash
bash init.sh <-pycharm> [2023.1.1] <-python> [3.10] <torch> [1.13.1]   
# 或 
# bash init.sh
```

init.sh可选参数

- <-pycharm> [2023.1.1]，到官网选择版本[Download PyCharm: Python IDE for Professional Developers by JetBrains](https://www.jetbrains.com/pycharm/download/#section=linux)
- <-python> [3.10]，python版本，默认3.10
- <torch> [1.13.1]，torch版本，默认1.13.1

## 参数解析

```bash
python x11vnc_desktop.py -h
```

| 命令参数 | 说明 |
| --- | --- |
| -h, --help  | 帮助信息 |
| -o OWNER, --owner OWNER | 镜像作者，默认”x11vnc”，pytorch版作者”maxwelllx” |
| -i IMAGE, --image IMAGE | 镜像名，以”/”开头，默认“/docker-desktop” |
| -t TAG, --tag TAG | 镜像标签，默认“zh_CN” |
| -v VOLUME, --volume VOLUME | 挂载common数据卷。默认为”x11vnc_common“，如果没有，则数据卷”x11vnc_common“将会被创建。建议挂载到/home/ubuntu/docker-containers/common |
| -w WORKDIR, --workdir WORKDIR | 设置起始工作目录，默认为/home/ubuntu/docker-containers/common |
| -p, --pull | 是否拉取镜像。初次使用采用这种方式下载镜像 |
| -r, --reset | 是否清空配置数据卷 |
| -c, --clear | 是否清空common数据卷 |
| -s SIZE, --size SIZE | 设置屏幕分辨率，默认为1920x1080或者屏幕原始分辨率。可设置1440x900, 1920x1080, 2560x1600等 |
| -n, --no-browser | 启动时不弹出网页noVNC，但是后续仍然可以手动连接 |
| --password | 设置VNC的连接密码，默认为123 |
| -V, --verbose | 详细模式。会在命令窗口打印尽可能更多信息，比如debug信息等 |
| -q, --quiet | 安静模式，与详细模式相反，尽可能少的输出信息 |
| -A ARGS | 附加参数。即docker run 的附件参数 |

## 端口映射与远程连接

container与host默认的端口映射

| host | container | 说明 |
| --- | --- | --- |
| 6080 | 6080 | noVNC |
| 5950 | 5900 | VNC |
| 2222 | 22 | SSH |
1. noVNC
    
    [http://localhost:6080/vnc.html?resize=downscale&autoconnect=1&password=123](http://localhost:6080/vnc.html?resize=downscale&autoconnect=1&password=123)
    
    非本机访问，替换localhost为目标ip，替换密码
    
2. VNC软件，推荐TigerVNC
    
    端口5950
    
3. SSH详见“-V”模式输出信息

## 宿主机路径-数据卷

| host | container | 数据卷说明 |
| --- | --- | --- |
| /home/$USER/docker-containers/common | /home/ubuntu/common | 多容器共享 |
| /home/$USER/.ssh | /home/ubuntu/.ssh | ssh配置 |
| /home/$USER/docker-containers/Project-1 | /home/ubuntu/Project-1 | 项目独享 |
| x11vnc_zh_CN_config | /home/ubuntu/.config | 镜像配置 |
| /home/$USER/.gnupg | /home/ubuntu/.gnupg | 系统配置 |

# 改动

### 修改调用显卡方法

- 删除“-N”，原版显卡启用方式（适用于Singularity）
- 添加”—gpus all”参数来启用Nvidia GPU（适用于Nvidia-docker2）

### 命令调整

- 删除”—rm”，容器关闭后不会被删除
- 删除“—detch”，原为后台运行，现在container不会自动删除，所以这条指令也就没必要了
- 默认密码设置为：123。方便本地使用，取消了原版的随机密码
- 添加“—gpus all“，为了深度学习用。（需要安装nvidia-docker2）
- 默认容器名：当前x11vnc_desktop.py所处的路径

### 添加软件

- 添加cmake、wget、gnome-terminal（终端）、gedit（文本编辑器）、Nautilus（文件管理器）
- 添加pycharm（社区版2022.3）
- 添加miniconda
- 添加conda环境，已安装（torch、numpy等常用算法包）
