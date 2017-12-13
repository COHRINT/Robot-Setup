# cohrint_turtlebot

## Cooperative Human Robotics Intelligence Lab Turtlebot Management Repo
This repository aims to centralize cohrint's odroids' software. It contains setup instructions for making a new robot (Robot Setup Section) and one repository for distributing and tracking all relevant files across odroids (Odroid File Tracking).

###  Robot Setup

#### Loading Ubuntu 16 onto eMMC
- Go to https://odroid.in/ubuntu_16.04lts/ and download the ubuntu-16.04-mate-odroid-u2u3-20160920.img.xz
- $ unxz -k ubuntu-16.04-mate-odroid-u2u3-20160920.img.xz
- Copy that image onto a flash drive
  $ cp ubuntu-16.04-mate-odroid-u2u3-20160920.img /mounting/directory/path
- umount and eject the flashdrive

USB-uSD-eMMC card readers are unreliable so we're going to use a hack to load the new Ubuntu 16 image onto the old eMMC
1. Boot a working odroid normally, connect via ssh
2. Connect the eMMC chip to a uSD-eMMC (cohrint's are blue and thin)
3. Connec the uSD/eMMC to the odroid via the uSD port
4. Attach the flash drive to the vertical port
5. $ sudo parted -l
   Check what name the flash drive came up under. Usually '/dev/sda'
6. $ sudo mount /dev/sda1 /mnt (or whichever name the flash drive came up as)
7. $ sudo dd if=/dev/zero of=/dev/mmcblk1 bs=1M count=8
   Clear the partition table of the bad eMMC
8. $ sudo dd if=/mnt/ubuntu-16.04-mate-odroid-u2u3-20160920.img of=/dev/mmcblk1 bs=4M conv=fsync
   This'll take a little while

#### Once the eMMC has Ubuntu 16

9. Plug the new Ubuntu 16 eMMC chip normally into an odroid. Attach a serial console to that odroid and your computer. Apply power to the odroid. On your computer run:
$ sudo screen /dev/ttyUSB0 115200n81 (check a screen commands cheatsheet for more help with screen)

If an error such as /dev/ttyUSB0 does not exist appears, your computer may have a differnt name instead of /dev/ttyUSB0 so replace that with the name that your computer assigns to the uart device - to find that simply plug in the device and run $ dmesg |tail and look for a /dev/tty... name that the kernel assigns it (/dev/ttyACMx /dev/ttyUSBx are the most common)

If the error [screen is terminating] appears, unplug and replug the serial USB from your computer and, in a new terminal, try running the command again.
      
10) You should see a terminal "odroid login: " Login as the user: *odroid*, password: *odroid*. (If you see no output on the terminal, try pressing enter a few times.)

LOGINS:
- User: **odroid**, Password: **odroid**
- User: **root**, Password: **odroid**

11) Plug in an ethernet cable and install git. Password: **odroid**
- $ sudo apt-get install git
12) Get cohrint_turtlebot
- $ git clone https://github.com/COHRINT/cohrint_turtlebot.git
- $ cd cohrint_turtlebot/install
13) Run and follow the steps in the shell script
- $ sudo bash basic_setup.sh robot_name
14) Run the second basic_setup2.sh shell script
- $ cd cohrint_turtlebot/install
- $ sudo bash basic_setup2.sh

#### For Installing Cops and Robots Dependencies
14) Install CnR dependencies
- $ sudo bash cnr_setup.sh
15) To set up quick aliases:
- $ bash get_cnr_aliases.sh

### Odroid File Tracking

This repository allows centralized file tracking among the odroids. Simply git commit changes and git pull on another odroid.
