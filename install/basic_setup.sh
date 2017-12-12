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

echo "We are gonig to set up the locales.\nIn the screen that follows hit enter on the 1st option for ALL_LOCALES. On the 2nd page that follows go down to en_US.UTF-8 and hit enter. Press [ENTER] to continue."
read -n 1

# Set up Locales, check if they've already been set
if ! [ -v LANG ]; then
    locale-gen "en_US.UTF-8" # Makes everthing POSIX except LANG, LANGUAGE and LC_ALL
    dpkg-reconfigure locales    # choose en_US.UTF-8, everything's still POSIX
    export LANGUAGE=en_US
    export LC_ALL=en_US.UTF-8
    update-locale LANGUAGE=en_US
    update-locale LC_ALL=en_US

    # After rebooting, everything's "en_US.UTF-8 except LANGUAGE and LC_ALL
    # Ran export then update-locale for first LANGUAGE then LC_ALL we'll see
    # everything seems to be set up correctly...
    # I need to pull some rebooting of the system stuff here..., maybe just logout and relogin?
    # export LANG=en_US.UTF-8
    # export LANGUAGE=en_US
    # export LC_ALL=en_US.UTF-8
    # update-locale LANG=en_US.UTF-8
    # update-locale LC_ALL=en_US.UTF-8
    # update-locale LANGUAGE=en_US
fi

echo "The hostname and locales have been set up correctly. When the system reboots, run $ sudo bash basic_setup2.sh as root. Press [ENTER] to continue."
read -n 1

reboot
exit 0
