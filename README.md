# docker-desktop-pytorch
一个带有桌面VNC的深度学习docker镜像。

基于项目[x11vnc/docker-desktop](https://hub.docker.com/r/x11vnc/docker-desktop/tags)

# 要求

- docker
- nvidia-docker2
- 宿主机已安装显卡驱动

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

## 镜像调整

### 添加软件

- 添加gnome-terminal
- 添加gedit
- 添加Nautilus（文件管理器）
- 添加pycharm（社区版2022.3）
- 添加miniconda
- 添加conda环境，已安装（torch、numpy等常用算法包）
- pycharm已配置PIP清华镜像源

# 使用方法

1. 准备文件，比如/home/$USER/docker_containers/路径中，新建common和Project-X（项目名）
    
    common和Porject-X是两个数据卷，功能上完全一致；用法上，common是一个共享数据卷，多个项目的共享空间，Porject-X项目专用的数据卷。
    

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

2. 运行。注意，使用此脚本创建多个container，必须保持其他的container为开启状态，否则端口将会被占用

```bash
cd /home/$USER/docker_containers/Project-1
curl -s -O https://raw.githubusercontent.com/Maxwell-lx/docker-desktop-pytorch/main/x11vnc_desktop.py
python x11vnc_desktop.py -o maxwelllx -i /docker-desktop-pytorch -v /home/$USER/docker-containers/common -V -p
```

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
    
    非本机访问，替换localhost为目标ip,替换密码
    
2. VNC软件，推荐TigerVNC
    
    端口5950
    
3. SSH详见“-V”模式输出信息
