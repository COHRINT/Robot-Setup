#!/bin/bash

# Odroid XU3 Ubuntu 16 Useful Aliases for running Cops and Robots
# Author: LT 12/12/17
# COHRINT Cooperative Human Robotics Intelligence Lab

echo -e "alias c='cd /home/odroid/catkin_ws/src/cohrint_turtlebot/'" >> /home/odroid/.bashrc
echo -e "alias cop='roslaunch /home/odroid/catkin_ws/src/cohrint_turtlebot/cnr/cop.launch'" >> /home/odroid/.bashrc
echo -e "alias rob='roslaunch /home/odroid/catkin_ws/src/cohrint_turtlebot/cnr/rob.launch'" >> /home/odroid/.bashrc
echo -e "alias recalib='rosservice call /vicon_bridge/calibrate_segment $HOSTNAME $HOSTNAME 0 100'" >> /home/odroid/.bashrc
source /home/odroid/.bashrc
