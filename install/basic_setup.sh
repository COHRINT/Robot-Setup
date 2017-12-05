#!/bin/bash

# Basic Oroid XU3 Ubuntu 16 Setup Script
# Tasks:
#      Setup hostname info
#      Blacklist old wifi driver, install the newest version
#      Setup locales
#      Install various common command line tools
# Author: LT 12/4/17
# COHRINT Cooperative Human Robotics Intelligence Lab

if [ "$#" -ne 1 ]
then
    echo "Pass the robot's name when running script"
    echo "e.g. $ bash basic_setup.sh zhora"
    exit 1
fi

# make name all lowercase
rob_name="${1,,}" 
echo "Robot name: $rob_name"

echo "Connect the odroid to an Ethernet cable. Press [ENTER] to continue"
read -n 1

exit 0
sudo apt-get update

