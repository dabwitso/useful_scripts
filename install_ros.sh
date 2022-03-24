#!/bin/bash
# Automatic installation of Ros Melodic or Noetic, assuming bash shell terminal used (.bashrc)
# Apache License 2.0
# Copyright (c) 2020, ROBOTIS CO., LTD.

echo "PRESS [ENTER] TO CONTINUE THE INSTALLATION"
echo "IF YOU WANT TO CANCEL, PRESS [CTRL] + [C]"
read


VERSION=$(lsb_release -a | grep Codename | cut -f2 -d ":")
echo ${VERSION}

if [ ${VERSION}="focal" ]
then
	echo "[Set the target OS, ROS version and name of catkin workspace]"
       	name_os_version=${name_os_version:="focal"}
	name_ros_version=${name_ros_version:="noetic"}

elif [ ${VERSION} = "bionic" ]
then
	echo "[Set the target OS, ROS version and name of catkin workspace]"
       	name_os_version=${name_os_version:="bionic"}
	name_ros_version=${name_ros_version:="melodic"}
else
	echo "This script does not support older versions of Ros1, or Ros2 setup. Please visit official website for installation"
	exit 1
fi

echo ""
echo "[Note] Target OS version  >>> Ubuntu (${name_os_version}) or Linux Mint"
echo "[Note] Target ROS version >>> ROS ${name_ros_version}"
echo "[Note] Catkin workspace   >>> $HOME/catkin_ws"
echo ""


user_shell=$(echo $SHELL)
shell=$(echo ${user_shell} | cut -f4 -d '/')


name_catkin_workspace=${name_catkin_workspace:="catkin_ws"}
echo "[Update the package lists]"
sudo apt update -y

echo "[Install build environment, the chrony, ntpdate and set the ntpdate]"
sudo apt install -y chrony ntpdate curl build-essential
sudo ntpdate ntp.ubuntu.com

echo "[Add the ROS repository]"
if [ ! -e /etc/apt/sources.list.d/ros-latest.list ]; then
  sudo sh -c "echo \"deb http://packages.ros.org/ros/ubuntu ${name_os_version} main\" > /etc/apt/sources.list.d/ros-latest.list"
fi

echo "[Download the ROS keys]"
roskey=`apt-key list | grep "Open Robotics"`
if [ -z "$roskey" ]; then
  curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
fi

echo "[Check the ROS keys]"
roskey=`apt-key list | grep "Open Robotics"`
if [ -n "$roskey" ]; then
  echo "[ROS key exists in the list]"
else
  echo "[Failed to receive the ROS key, aborts the installation]"
  exit 0
fi

echo "[Update the package lists]"
sudo apt update -y

echo "[Install ros-desktop-full version of ${name_ros_version}"
sudo apt install -y ros-$name_ros_version-desktop-full

echo "[Install RQT & Gazebo]"
sudo apt install -y ros-$name_ros_version-rqt-* ros-$name_ros_version-gazebo-*

echo "[Environment setup and getting rosinstall]"
echo "source /opt/ros/${name_ros_version}/setup.${shell}" >> ~/.${shell}rc
sudo apt install -y python3-rosinstall python3-rosinstall-generator python3-wstool build-essential git

echo "[Install rosdep and Update]"
sudo apt install python3-rosdep

echo "[Initialize rosdep and Update]"
sudo sh -c "rosdep init"
rosdep update

echo "[Make the catkin workspace and test the catkin_make]"
mkdir -p $HOME/$name_catkin_workspace/src
cd $HOME/$name_catkin_workspace/src
catkin_init_workspace
cd $HOME/$name_catkin_workspace
catkin_make

echo "[Set the ROS evironment]"
sh -c "echo \"alias eb='nano ~/.bashrc'\" >> ~/.bashrc"
sh -c "echo \"alias sb='source ~/.bashrc'\" >> ~/.bashrc"
sh -c "echo \"alias gs='git status'\" >> ~/.bashrc"
sh -c "echo \"alias gp='git pull'\" >> ~/.bashrc"
sh -c "echo \"alias cw='cd ~/$name_catkin_workspace'\" >> ~/.bashrc"
sh -c "echo \"alias cs='cd ~/$name_catkin_workspace/src'\" >> ~/.bashrc"
sh -c "echo \"alias cm='cd ~/$name_catkin_workspace && catkin_make'\" >> ~/.bashrc"

sh -c "echo \"source /opt/ros/$name_ros_version/setup.bash\" >> ~/.bashrc"
sh -c "echo \"source ~/$name_catkin_workspace/devel/setup.bash\" >> ~/.bashrc"

sh -c "echo \"export ROS_MASTER_URI=http://localhost:11311\" >> ~/.bashrc"
sh -c "echo \"export ROS_HOSTNAME=localhost\" >> ~/.bashrc"

source $HOME/.${shell}rc

echo "[Complete!!!]"
exit 0
