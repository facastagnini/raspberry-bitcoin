Raspberry-Bitcoin
=================

== THIS IS WORK IN PROGRESS==

Build a full node + miner with a Raspberry Pi B 512MB.

DISCLAIMER: This is a personal project to learn about Bitcoin and how to colaborate to keep the distribuited network strong and healthy. This is NOT an attempt to make money.


Installation
------------

1) Install Raspbian on a 16Gb or bigger SD card. (There is a guide here http://www.raspberrypi.org/documentation/installation/installing-images/README.md)

2) Upgrade the system, add base packages, optimize and expand RAM (installing ZRAM)

	# upgrade the system
	apt-get update
	apt-get dist-upgrade
	apt-get install rpi-update htop iotop usbutils

	# log in ram
	service rsyslog stop
	echo "tmpfs		/var/log	tmpfs	nosuid,noexec,nodev,mode=0755,size=32M" >>/etc/fstab
	rm -r /var/log/*
	mount /var/log
	service rsyslog start

	# /tmp in ram
	echo "RAMTMP=yes" >> /etc/default/tmpfs

	# update the firmware
	rpi-update

	# Remove the extra tty's
	sed -i '/[2-6]:23:respawn:\/sbin\/getty 38400 tty[2-6]/s%^%#%g' /etc/inittab

	# Optimize / mount
	#sed -i 's/defaults,noatime/defaults,noatime,nodiratime/g' /etc/fstab

	# Disable IPv6
	echo "net.ipv6.conf.all.disable_ipv6=1" > /etc/sysctl.d/disableipv6.conf
	echo 'blacklist ipv6' >> /etc/modprobe.d/blacklist
	sed -i '/::/s%^%#%g' /etc/hosts

	# cNOOP scheduler is best used with solid state devices such as flash memory.
	sed -i 's/deadline/noop/g' /boot/cmdline.txt

	# remove syslog
	# apt-get -y remove --purge rsyslog

	# compile zram module
	apt-get install linux-headers-rpi-rpfv

	# drop the zram script
	echo << EOF >/etc/init.d/zram
	#!/bin/bash
	### BEGIN INIT INFO
	#Provides: zram
	#Required-Start:
	#Required-Stop:
	#Default-Start: 2 3 4 5
	#Default-Stop: 0 1 6
	#Short-Description: Increased Performance In Linux With zRam (Virtual Swap Compressed in RAM)
	#Description: Adapted for Raspian (Rasberry pi) by eXtremeSHOK.com using https://raw.github.com/gionn/etc/master/init.d/zram
	### END INIT INFO
	 
	start() {
	    mem_total_kb=$(grep MemTotal /proc/meminfo | grep -E --only-matching '[[:digit:]]+')
	 
	    modprobe zram
	 
	    sleep 1
	    #only using 50% of system memory, comment the line below to use 100% of system memory
	    mem_total_kb=$((mem_total_kb/2))
	 
	    echo $((mem_total_kb * 1024)) > /sys/block/zram0/disksize
	 
	    mkswap /dev/zram0
	 
	    swapon -p 100 /dev/zram0
	}
	 
	stop() {
	    swapoff /dev/zram0
	    sleep 1
	    rmmod zram
	}
	 
	case "$1" in
	    start)
	        start
	        ;;
	    stop)
	        stop
	        ;;
	    restart)
	        stop
	        sleep 3
	        start
	        ;;
	    *)
	        echo "Usage: $0 {start|stop|restart}"
	        RETVAL=1
	esac
	EOF
	chmod +x /etc/init.d/zram
	
	#add zram.enabled=1 to /boot/cmdline.txt

	# start on boot disable, rpi official firmware misses the zram module
	# update-rc.d zram defaults

	# done, reboot
	reboot


3) Clone this git repo.

	apt-get install git
	cd /root
	git clone git@github.com:facastagnini/raspberry-bitcoin.git


4) Setup the full node.
   A full node is bla bla bla and provides this this and this and help Bitcoin in this way.

   Since the Raspbian repositories host an archaic version of Bitcoin Core (the original Bitcoin client), we will have to compile from source.


	# install building dependencies
	apt-get install build-essential autoconf libssl-dev libboost-dev libboost-chrono-dev libboost-filesystem-dev libboost-program-options-dev libboost-system-dev libboost-test-dev libboost-thread-dev

	# install Berkeley DB from source
	cd /usr/src
	wget http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz
	tar -xzvf db-4.8.30.NC.tar.gz
	cd db-4.8.30.NC/build_unix/

	../dist/configure --enable-cxx
	make
	sudo make install

	# create a temporary swap file
	dd if=/dev/zero of=/opt/swapfile bs=1024 count=1024000
	mkswap /opt/swapfile
	swapon /opt/swapfile

	# install Bitcoin Core
	cd /usr/src
	git clone -b 0.9.3 https://github.com/bitcoin/bitcoin.git
	cd bitcoin/
	./autogen.sh
	./configure --disable-wallet
	make
	make install

	# remove the swap file
	swapoff /opt/swapfile

        # setup the bitcoin config file
        mkdir /root/.bitcoin
        ln /root/raspberry-bitcoin/bitcoin.conf /root/.bitcoin/bitcoin.conf

        # start the bitcoin daemon
        /usr/local/bin/bitcoind -conf=/root/.bitcoin/bitcoin.conf


Bitcoind will connect to some peers and start downloading the blockchain. You can monitor the progress with the folowing command:

	bitcoind getinfo

CREDIT: I based this part of the instruccions on this excelent article -> http://blog.pryds.eu/2014/06/compile-bitcoin-core-on-raspberry-pi.html

5) Install CGMiner 

	# install building dependencies
	apt-get install libusb-1.0-0-dev libusb-1.0-0 libcurl4-openssl-dev libncurses5-dev libudev-dev

	# install from source
	cd /usr/src
	wget http://ck.kolivas.org/apps/cgminer/cgminer-4.7.0.tar.bz2
	tar xvf cgminer-4.7.0.tar.bz2
	ln -sf /usr/src/cgminer-4.7.0 /usr/src/cgminer
	cd cgminer
	CFLAGS="-O2 -Wall" ./configure --enable-icarus
	make

	# setup the bitcoin config file
	cp /root/raspberry-bitcoin/cgminer.conf /etc/cgminer.conf
	# edit the configuration add the pool url, user and password. If you are mining 'solo' point to your local bitcoind node
	vi /etc/cgminer.conf 

6) Install adafruit goodies

6.1) Adafruit GPIO: https://learn.adafruit.com/adafruits-raspberry-pi-lesson-4-gpio-setup

6.2) Adafruit 16x2 Character LCD: https://learn.adafruit.com/adafruit-16x2-character-lcd-plus-keypad-for-raspberry-pi/overview

6.3) Install PiMiner

	cd /usr/src
	git clone https://github.com/adafruit/PiMiner.git

7) Monitoring

	cd /usr/src
	# install google python library
	wget https://gdata-python-client.googlecode.com/files/gdata-2.0.18.tar.gz
	tar xvf gdata-2.0.18.tar.gz
	cd gdata-2.0.18
	python setup.py install
	python tests/run_data_tests.py
	vi samples/docs/docs_example.py

8) Auto-start on boot.
   Make your /etc/rc.local look something like this:

	#!/bin/sh -e
	#
	# rc.local
	#
	# This script is executed at the end of each multiuser runlevel.
	# Make sure that the script will "exit 0" on success or any other
	# value on error.
	#
	# In order to enable or disable this script just change the execution
	# bits.
	#
	# By default this script does nothing.
	
	# print the IP address
	echo "My IP address is $(hostname -I)" || true
	
	# start bitcoind
	/usr/local/bin/bitcoind -conf=/root/.bitcoin/bitcoin.conf
	
	cd /usr/src/PiMiner
	python PiMiner.py &
	nohup /usr/src/cgminer/cgminer --config /etc/cgminer.conf >/dev/null 2>&1&
	
	exit 0



Firewall rules
--------------

Don't forget to forward traffic on port 8333 to the Raspberry Pi.


ASIC USB miner
--------------

I am using BITMAIN ANTMINER U2+ ASIC Bitcoin Miner (http://www.amazon.com/gp/product/B00JT3HMRI)

Download the latest version of cgminer, currently v4.3.0. Configure the "anu-freq" setting to change the speed of your U2 devices as follows: 200 (default) for 1.6 Gh/s, 250 for 2.0 Gh/s, 275 for 2.2 Gh/s, or 300 for 2.4 Gh/s.

bfgminer.exe -o pool -u user -p pass -S erupter:all -S antminer:all --set-device antminer:clock=x0981 --icarus-options 115200:2:2

antminer_clock_settings:
	0781 = 1.6 Ghps
	0881 = 1.8 Ghps
	0981 = 2.0 Ghps
	0A01 = 2.1 Ghps
	0A81 = 2.2 Ghps
	0B01 = 2.3 Ghps
	0B81 = 2.4 Ghps

REFERENCE: https://github.com/AntMiner/AntGen1


Contributing
------------

Forks, patches and other feedback are welcome.
