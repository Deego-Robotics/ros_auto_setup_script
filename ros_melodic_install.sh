#!/bin/bash

## Author: Deego Robotics

mypassword="$1"

echo "$mypassword" |sudo -S sh -c 'rm /var/lib/dpkg/lock-frontend'
echo "$mypassword" |sudo -S sh -c 'rm /var/cache/apt/archives/lock'
echo "$mypassword" |sudo -S sh -c 'rm /var/lib/dpkg/lock'

## 1.1 Setup your source list
echo "$mypassword" |sudo -S sh -c 'sed -i 'd' /etc/apt/sources.list'
echo "$mypassword" |sudo -S sh -c '
cat >> /etc/apt/sources.list << EOF

# 默认注释了源码仓库，如有需要可自行取消注释
deb https://mirrors.ustc.edu.cn/ubuntu/ bionic main restricted universe multiverse
# deb-src https://mirrors.ustc.edu.cn/ubuntu/ bionic main restricted universe multiverse

deb https://mirrors.ustc.edu.cn/ubuntu/ bionic-security main restricted universe multiverse
# deb-src https://mirrors.ustc.edu.cn/ubuntu/ bionic-security main restricted universe multiverse

deb https://mirrors.ustc.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse
# deb-src https://mirrors.ustc.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse

deb https://mirrors.ustc.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse
# deb-src https://mirrors.ustc.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse

# 预发布软件源，不建议启用
# deb https://mirrors.ustc.edu.cn/ubuntu/ bionic-proposed main restricted universe multiverse
# deb-src https://mirrors.ustc.edu.cn/ubuntu/ bionic-proposed main restricted universe multiverse

EOF
'

## 1.2 Set up your keys
sudo apt-get -y update
sudo apt-get -y upgrade
echo "$mypassword" |sudo -S apt -y install curl
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F42ED6FBAB17C654

## 1.3 Setup your sources.list
echo "$mypassword" |sudo -S sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
# sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

## 1.4 Installation
sudo apt update
sudo apt-get -y install ros-melodic-desktop-full

## 1.5 Environment setup
rossource="source /opt/ros/melodic/setup.bash"
if grep -Fxq "$rossource" ~/.bashrc; then echo ROS setup.bash already in .bashrc;
else echo "$rossource" >> ~/.bashrc; fi
eval $rossource

## 1.6 Dependencies for building packages
echo "$mypassword" |sudo -S apt -y install python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential
sudo apt-get -y install python3-pip
sudo pip3 install 6-rosdep
sudo 6-rosdep
sudo rosdep init
rosdep update

echo "$mypassword" |sudo -S apt -y install libgoogle-glog-dev
