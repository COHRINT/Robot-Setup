#!/bin/bash

# Basic Oroid XU3 Ubuntu 16 Setup Script
# Tasks:
#      Setup hostname info
#      Setup locales
# Author: LT 12/11/17
# COHRINT Cooperative Human Robotics Intelligence Lab

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

if [ "$#" -ne 1 ]; then
    echo "Pass the robot's name when running script"
    echo "e.g. $ bash basic_setup.sh zhora"
    exit 1
fi

# make name all lowercase
robot_name="${1,,}" 
echo "Robot name: $robot_name"

echo "Connect the odroid to an Ethernet cable. Press [ENTER] to continue"
read -n 1

echo "Updating repositories"
apt-get update

# Set up hostname
touch /etc/hostname
echo "$robot_name" > /etc/hostname
sed -i 's/odroid/'"$robot_name"'/g' /etc/hosts

echo "Enter the new password for $robot_name"
passwd odroid

echo "---------------------------"
echo -e "We are gonig to set up the locales.\nOn the first screen just hit enter.\nOn the second screen select 'en_US.UTF-8' then hit enter. Press [ENTER] to continue."
read -n 1

# Set up Locales, these need to be in the order shown below...
locale-gen "en_US.UTF-8" # Makes everthing POSIX except LANG, LANGUAGE and LC_ALL
dpkg-reconfigure locales    # choose en_US.UTF-8, everything's still POSIX
export LANGUAGE=en_US
export LC_ALL=en_US.UTF-8
update-locale LANGUAGE=en_US
update-locale LC_ALL=en_US.UTF-8

echo "---------------------------"
echo -e "The hostname and locales have been set up. When the system reboots, run basic_setup2.sh as root.\nPress [ENTER] to continue."
read -n 1

reboot
exit 0
