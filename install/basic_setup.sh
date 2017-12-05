#!/bin/bash

# Basic Oroid XU3 Ubuntu 16 Setup Script
# Tasks:
#      Setup hostname info
#      Blacklist old wifi driver, install the newest version
#      Setup locales
#      Install various common command line tools
# Author: LT 12/4/17
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
echo "$robot_name" >> /etc/hostname
sed -i 's/odroid/$robot_name/g' /etc/hosts

# Set up Locales
if ! [ -v LANG ]; then
export LANG=en_US.UTF-8
export LANGUAGE=en_US
export LC_ALL=en_US.UTF-8
update-locale LC_ALL=en_US.UTF-8
update-locale LANGUAGE=en_US
update-locale LANG=en_US.UTF-8
fi

# Setup the netowrk keys
echo "What is the password to RECUV-VICON?"
read password
echo "If you need to change the password, go to /etc/network/interfaces and edit the wpa_psk value, press [ENTER] to continue"
read -n 1

# Append the password to the network file
cp setup_files/interfaces interfaces # make a new file in current dir
echo -e "\twpa_psk \"$password\"" >> interfaces
echo "iface default inet dhcp" >> interfaces
mv interfaces /etc/network/interfaces # replace the other network file

# Setup a functional wifi driver
# 1) Empty udev to fix wireless dev naming
touch /etc/udev/rules.d/80-net-setup-link.rules
# 2) Allow systemd to properly start up and not look for these
sudo cp setup_files/cups-filters.conf /etc/modules-load.d/
# 3) Install 3.8.13.30 kernel headers
cd /home/odroid
wget https://secure-web.cisco.com/1H2IEOqkUKR5Fs1_R030aqKJcV8MepwP6Dsm2tQ-AmhKydvWLIgO2WVfnT9oTiDgOIpbslZwxYkGGJJHPn-3bXs2DFWoo5RY7W_9NrtSvNHPbtIq3I67SQs-lBtUUB4DISPweJg70L_wwBS6RMeakTcZ3-is--6aaXU34hlY4FxfESM760jFu7VBgj8QmOn-OIQBhY8YyXLeYbJuyS5rGLyC39Gt6V6SYtEoBCdiqWe79-yoqv6sI_N91sOzIbSCNlIXfygkhPC89V1X-aZOzMwnP08USr6UpP09YgFVNUlu85qFrOYZCQahcjvVHAOp13eyKSY-_vLQHNKAcoPdRL3rLIHhzZ7geklOBaQZ2YD5LchyfhUj6pGbq65fOwOzlHI9oNrLVsCt_DYLA02R6SVTCMRgiKy-lkxhQBs9buHyindE6GH-t5VgWdN1DtR9KxBA11LBJ_P7W_T2dApK80A/https%3A%2F%2Foph.mdrjr.net%2Fmeveric%2Fpool%2Fx2%2Fl%2Flinux-source-3.8.13.30%2Flinux-headers-3.8.13.30_3.8.13.30-20161026-X2_armhf.deb

# 4) Unpackage the headers
dpkg -i linux-headers-3.8.13.30_3.8.13.30-20161026-X2_armhf.deb

# 5) New driver for the rtl8192cu
git clone https://github.com/cmicali/rtl8192cu_beaglebone
cd rtl8192cu_beaglebone
# 6) Build the source code w/o cross compiling
make CROSS_COMPILE=''
# 7) Copy the generated driver file to the drivers dir
cp 8192cu.ko /lib/modules/3.8.13.30
# 8) Rebuild driver modules
depmod -a
# 9) Blacklist the old driver
cp setup_files/blacklist-rtl8192cu.conf /etc/modprobe.d/
# 10) Network Manager no bueno
systemctl disable NetworkManager-wait-online.service

# Install various command line tools
apt-get locate
updatedb

apt-get install nano
apt-get install emacs # most important 

# Add more command line installs here...

echo "Insert the wifi dongle into the odroid. Press [ENTER] to contiue."
read -n 1

echo "The system will reboot, when it begins again the wifi dongle should be blinking and $ ssh odroid@$robot_name should be possible. Press [ENTER] to continue."
read -n 1

reboot
exit 0

