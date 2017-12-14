#!/bin/bash

#  Oroid XU3 Ubuntu 16 Setup Script
# Tasks:
#      Install ROS
#      Set up ROS env variables
#      Install UVC camera node and image proc
# Author: LT 12/12/17
# COHRINT Cooperative Human Robotics Intelligence Lab

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116

echo 'Plug in the ethernet cable and press [ENTER] (Install speed is much faster)'
read n -1

apt-get update

apt-get install ros-kinetic-navigation
apt-get install ros-kinetic-pcl-ros
apt-get install ros-kinetic-turtlebot
apt-get install ros-kinetic-turtlebot-navigation
apt-get install ros-kinetic-rosbridge-suite
apt-get install ros-kinetic-map-server

apt-get install ros-kinetic-uvc-camera
apt-get install ros-kinetic-image-proc
apt-get install ros-kinetic-image-transport-plugins

usermod -a -G video odroid

# Let's replace the turtlebot_node.py file
cp turlebot_files/turtlebot_node.py /opt/ros/kinetic/lib/create_node/
updatedb

# we want to make the rest of this as odroid
su - odroid

echo "--------------------------"
echo "Making a catkin workspace. Press [ENTER] to continue"
read -n 1

source /opt/ros/kinetic/setup.bash
# Create a catkin worksapce
mkdir -p /home/odroid/catkin_ws/src
cd /home/odroid/
# Move cohrint_turtlebot into the catkin workspace
mv cohrint_turtlebot /home/odroid/catkin_ws/src/
cd catkin_ws/
catkin_make
source devel/setup.bash

cd /home/odroid

# Correct the bash rc's path
sed -i 's/cohrint_turtlebot;git/''catkin_ws\/src\/cohrint_turtlebot;git''/g' /home/odroid/.bashrc

# Add Turtlebot Variables
echo 'source /opt/ros/kinetic/setup.bash' >> /home/odroid/.bashrc
echo 'source /home/odroid/catkin_ws/devel/setup.bash' >> /home/odroid/.bashrc
echo 'export ROS_MASTER_URI=http://${SSH_CLIENT%% *}:11311' >> /home/odroid/.bashrc
echo 'export ROBOT=$HOSTNAME' >> /home/odroid/.bashrc

echo 'export TURTLEBOT_3D_SENSOR=kinect' >> /home/odroid/.bashrc
echo 'export TURTLEBOT_STACKS=circles' >> /home/odroid/.bashrc
echo 'export TURTLEBOT_BASE=create' >> /home/odroid/.bashrc
echo 'export TURTLEBOT_SERIAL_PORT=/dev/ttyUSB0' >> /home/odroid/.bashrc

# Find the hostname
case "$HOSTNAME" in
    "deckard")
	export rob_ip="121"
	;;
    "roy")
	export rob_ip="122"
	;;
    "pris")
	export rob_ip="123"
	;;
    "zhora")
	export rob_ip="124"
	;;
    *) echo "Robot hostname not properly setup"
       echo "change the bashrc to properly reflect the ROS_HOSTNAME number"
       export rob_ip="#"
       ;;
esac

echo 'export ROS_HOSTNAME=192.168.20.'$rob_ip >> /home/odroid/.bashrc

source /home/odroid/.bashrc

echo "---------------------------"
echo 'Press [ENTER] to reboot. '$HOSTNAME' is now a fully functional cop and robber.'
read -n 1

reboot
