#!/bin/bash

# 设置默认值
PYCHARM_VERSION="2023.1.1"
PYTHON=3.10
TORCH=1.13.1

# 处理命令行参数
while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        -pycharm)
        PYCHARM_VERSION="$2"
        shift # 将参数指针向后移动
        shift
        ;;
        -python)
        PYTHON="$2"
        shift
        shift
        ;;
        -torch)
        TORCH="$2"
        shift
        shift
        ;;
        *)  # 未知参数
        echo "未知的参数： $1"
        exit 1
        ;;
    esac
done

# 输出结果
echo "PYCHARM_VERSION: $PYCHARM_VERSION"
echo "PYTHON: $PYTHON"
echo "TORCH: $TORCH"

# 安装gnome-terminal、gedit、Nautilus、cmake、wget 
sudo apt-get update
sudo apt-get install -y gnome-terminal 
sudo apt-get install -y gedit

sudo apt-get update
sudo apt-get install -y Nautilus
sudo apt-get install -y cmake
sudo apt-get install -y wget 

# 删除文件夹shared
rm -rf /home/ubuntu/shared

# 下载，解压，安装pycharm社区版

wget "https://download.jetbrains.com.cn/python/pycharm-community-$PYCHARM_VERSION.tar.gz"
tar -xf "pycharm-community-$PYCHARM_VERSION.tar.gz" -C /home/ubuntu
rm "pycharm-community-$PYCHARM_VERSION.tar.gz"
mv /home/ubuntu/pycharm-community-$PYCHARM_VERSION /home/ubuntu/pycharm
echo "PyCharm $PYCHARM_VERSION has been installed successfully."

# 下载，安装miniconda  https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sudo bash Miniconda3-latest-Linux-x86_64.sh -b -p /home/ubuntu/miniconda
rm Miniconda3-latest-Linux-x86_64.sh
source /home/ubuntu/miniconda/bin/activate
sudo chown -R $USER:$USER /home/ubuntu/miniconda

# 创建python虚拟环境
conda create -n deeplearning python=$PYTHON pytorch=$TORCH -y


# 桌面创建快捷方式 
echo -e "[Desktop Entry]\nType=Application\nName=GNOME Terminal\nExec=gnome-terminal\nIcon=utilities-terminal\nCategories=System;TerminalEmulator;" > /home/ubuntu/Desktop/gnome-terminal.desktop
echo -e "[Desktop Entry]\nVersion=1.0\nName=Nautilus\nComment=Launch Nautilus file manager\nExec=nautilus\nTerminal=false\nType=Application\nIcon=/usr/share/icons/hicolor/48x48/apps/nautilus.png\nCategories=Utility;FileManager;" > /home/ubuntu/Desktop/Nautilus.desktop
echo -e "[Desktop Entry]\nVersion=1.0\nName=pycharm start\nComment=Launch /pycharm/bin/pycharm.sh script\nExec=/home/ubuntu/pycharm/bin/pycharm.sh\nTerminal=false\nType=Application\nIcon=/home/ubuntu/pycharm/bin/pycharm.png\nCategories=Utility;" > /home/ubuntu/Desktop/pycharm_start.desktop
echo -e "[Desktop Entry]\nName=gedit\nExec=gedit\nType=Application\nTerminal=false\nIcon=/usr/share/icons/hicolor/48x48/apps/gedit.png\nCategories=TextEditor;" > /home/ubuntu/Desktop/gedit.desktop

# 剪切icon
sudo mv gedit.png /usr/share/icons/hicolor/48x48/apps/gedit.png
sudo mv nautilus.png /usr/share/icons/hicolor/48x48/apps/nautilus.png


# 删除readme、xvnc11_desktop.py、init.sh
rm -f README.md
rm -f xvnc11_desktop.py
rm -f init.sh