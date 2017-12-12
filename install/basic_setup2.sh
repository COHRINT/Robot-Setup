#!/bin/bash

# Basic Oroid XU3 Ubuntu 16 2nd Setup Script
# Tasks:
#      Blacklist old wifi driver, install the newest version
#      Install various common command line tools
# Author: LT 12/12/17
# COHRINT Cooperative Human Robotics Intelligence Lab

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
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
cp setup_files/cups-filters.conf /etc/modules-load.d/
# 3) Install 3.8.13.30 kernel headers
cd /home/odroid
wget https://secure-web.cisco.com/1H2IEOqkUKR5Fs1_R030aqKJcV8MepwP6Dsm2tQ-AmhKydvWLIgO2WVfnT9oTiDgOIpbslZwxYkGGJJHPn-3bXs2DFWoo5RY7W_9NrtSvNHPbtIq3I67SQs-lBtUUB4DISPweJg70L_wwBS6RMeakTcZ3-is--6aaXU34hlY4FxfESM760jFu7VBgj8QmOn-OIQBhY8YyXLeYbJuyS5rGLyC39Gt6V6SYtEoBCdiqWe79-yoqv6sI_N91sOzIbSCNlIXfygkhPC89V1X-aZOzMwnP08USr6UpP09YgFVNUlu85qFrOYZCQahcjvVHAOp13eyKSY-_vLQHNKAcoPdRL3rLIHhzZ7geklOBaQZ2YD5LchyfhUj6pGbq65fOwOzlHI9oNrLVsCt_DYLA02R6SVTCMRgiKy-lkxhQBs9buHyindE6GH-t5VgWdN1DtR9KxBA11LBJ_P7W_T2dApK80A/https%3A%2F%2Foph.mdrjr.net%2Fmeveric%2Fpool%2Fx2%2Fl%2Flinux-source-3.8.13.30%2Flinux-headers-3.8.13.30_3.8.13.30-20161026-X2_armhf.deb

# 4) Unpackage the headers
dpkg -i *linux-headers-3.8.13.30_3.8.13.30-20161026-X2_armhf.deb
rm *linux-headers-3.8.13.30_3.8.13.30-20161026-X2_armhf.deb

# Have the symlink "build" point to the correct kernel
rm /lib/modules/3.8.13.30/build
ln -s /usr/src/linux-headers-3.8.13.30/ /lib/modules/3.8.13.30/build

# 5) New driver for the rtl8192cu
git clone https://github.com/cmicali/rtl8192cu_beaglebone /home/odroid/rtl8192cu_beaglebone
cd /home/odroid/rtl8192cu_beaglebone
# 6) Build the source code w/o cross compiling
make CROSS_COMPILE=''
# 7) Copy the generated driver file to the drivers dir
cp 8192cu.ko /lib/modules/3.8.13.30
# 8) Rebuild driver modules
depmod -a
# 9) Blacklist the old driver
cd /home/odroid/cohrint_turtlebot/install 
cp setup_files/blacklist-rtl8192cu.conf /etc/modprobe.d/
# 10) Network Manager no bueno
systemctl disable NetworkManager-wait-online.service
# change the possible wait time to 30sec instead of 5 min
mv setup_files/networking.service /etc/systemd/system/network-online.target.wants/ # apparently this did not work correctly...

# append to the bashrc to update the robot's git info eachtime
echo -e "\nUpdate the cohrint_turtlebot git repo on each login" >> /home/odroid/.bashrc
echo -e 'cd /home/odroid/cohrint_turtlebot;git pull' >> /home/odroid/.bashrc
echo -e 'cd /home/odroid' >> /home/odroid/.bashrc

# Install various command line tools
apt-get install locate
updatedb

apt-get install nano
# No emacs .. sad

# Add more command line installs here...



echo 'Insert the wifi dongle into the odroid. Press [ENTER] to contiue.'
read -n 1

echo 'The system is rebooting. When it begins again the wifi dongle should be blinking and $ ssh odroid@$robot_name will be possible. Press [ENTER] to continue.'
read -n 1

reboot
exit 0
