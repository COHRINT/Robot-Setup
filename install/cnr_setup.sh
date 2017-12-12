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

apt-get update

apt-get install ros-kinetic-navigation
apt-get install ros-kinetic-pcl-ros
apt-get install ros-kinetic-turtlebot
apt-get install ros-kinetic-turtlebot-navigation
apt-get install ros-kinetic-rosbridge-suite
apt-get install ros-kinetic-map-server

# Add Turtlebot Variables
echo 'source /opt/ros/kinetic/setup.bash' >> /home/odroid/.bashrc
echo 'export ROS_MASTER_URI=http://${SSH_CLIENT%% *}:11311' >> /home/odroid/.bashrc
echo 'export ROS_HOSTNAME=192.168.20.124' >> /home/odroid/.bashrc
echo 'export ROBOT=$HOSTNAME' >> /home/odroid/.bashrc

echo 'export TURTLEBOT_3D_SENSOR=kinect' >> /home/odroid/.bashrc
echo 'export TURTLEBOT_STACKS=circles' >> /home/odroid/.bashrc
echo 'export TURTLEBOT_BASE=create' >> /home/odroid/.bashrc
echo 'export TURTLEBOT_SERIAL_PORT=/dev/ttyUSB0' >> /home/odroid/.bashrc

source /home/odroid/.bashrc

