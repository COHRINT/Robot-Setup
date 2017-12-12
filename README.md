# cohrint_turtlebot

## Cooperative Human Robotics Intelligence Lab Turtlebot Management Repo
This repository aims to centralize cohrint's odroids' software. It contains setup instructions for making a new robot (Robot Setup Section) and one repository for distributing and tracking all relevant files across odroids (Odroid File Tracking).

###  Robot Setup
To setup a new robot:
- Go to https://odroid.in/ubuntu_16.04lts/ and download the ubuntu-16.04-mate-odroid-u2u3-20160920.img.xz
- $ unxz -k ubuntu-16.04-mate-odroid-u2u3-20160920.img.xz

Connect the eMMC through the usb-uSD-eMMC adapter to your computer
1. Find the device name of the eMMC chip (/dev/sdX) (X is a letter a,b,c...)
you can do this through $ sudo parted -l and looking for the right device
*IT IS VERY IMPORTANT YOU PICK THE RIGHT DEVICE, OR ELSE YOU'LL WRITE TO ANOTHER DISK ON YOUR HARDRIVE" disk destroyer (dd) 
$ mount |grep /dev/sdX
2. If you see output such as /dev/sdX1 and /dev/sdX2 umount those:
$ sudo umount /dev/sdX1 /dev/sdX2
Recheck mount |grep /dev/sdX and make sure there's no output, umount that partition if there's still something
3. zero out the eMMC's current partition table (first 8 or so kilobytes)
$ sudo dd if=/dev/zero of=/dev/sdX
4. load the image onto the eMMC (this'll take awhile)
$ sudo dd if=ubuntu-16.04-mate-odroid-u2u3-20160920.img of=/dev/sdX bs=4M conv=fsync
5. Once done, right click on one of the two USB icons that pops up and click "Eject Parent Drive"
6. Remove the eMMC from your computer and plug it into an Odroid, plug in a wifi dongle and hook up a serial console to the odroid and usb and in a terminal on your computer run:
$ sudo screen /dev/ttyUSB0 115200n81 (check a screen commands cheatsheet if you get stuck)
(your computer may have a differnt name instead of /dev/ttyUSB0 so replace that with the name that your computer assigns to the uart device - to find that simply plug in the device and run $ dmesg |tail and look for a /dev/tty... name that the kernel it assigns it)
7) Press enter a few times and you should see a terminal odroid@odroid:~$
You're in
User: **odroid**
Password: **odroid**
User: **root**
Password: **odroid**

8) Plug in an ethernet cable and install git
password: **odroid**
$ sudo apt-get install git
9) Get cohrint_turtlebot
$ cd ~
$ git clone https://github.com/COHRINT/cohrint_turtlebot.git
$ cd ~/cohrint_turtlebot/install
10) Follow the steps in the shell script
$ bash basic_setup.sh robot_name

#### For Installing Cops and Robots Dependencies
11) bash cnr_setup.sh
12) bash get_cnr_aliases.sh

### Odroid File Tracking

This repository allows centralized file tracking among the odroids. Simply git commit changes and git pull on another odroid.


add git config for the shell script