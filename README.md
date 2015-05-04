Raspberry-Bitcoin
=================

[![Build Status](https://secure.travis-ci.org/facastagnini/raspberry-bitcoin.svg?branch=master)](https://travis-ci.org/facastagnini/raspberry-bitcoin)[1]
[![Code Coverage](http://img.shields.io/coveralls/facastagnini/raspberry-bitcoin.svg)][2]
[![Dependencies](http://img.shields.io/gemnasium/facastagnini/raspberry-bitcoin.svg)][3]


THIS IS WORK IN PROGRESS: I am writing chef code to automate/manage the installation.

This is an attempt to build a full bitcoin node on a Raspberry Pi 2 B (4 cores, 1GB ram).

It is NOT possible to run a full node on the raspberry pi 1 B. Not enought CPU, neither RAM.

DISCLAIMER: This is a personal project to learn about Bitcoin and how to colaborate to keep the distribuited network strong and healthy. This is not an attempt to make money.


Installation
------------

1) Install Raspbian on a 4Gb or bigger SD card. (There is a guide here http://www.raspberrypi.org/documentation/installation/installing-images/README.md)

2) Finish the installation and move the rootfs to an external usb hard drive (LINK).

3) Cook the pi (reference: http://everydaytinker.com/raspberry-pi/installing-chef-client-on-a-raspberry-pi-2-model-b/)

```bash
curl -sL https://raw.githubusercontent.com/facastagnini/raspberry-bitcoin/master/bootstrap.sh | sudo bash
```

4) Update with:
```bash
sudo rm -rf /usr/src/raspberry-bitcoin/berks-cookbooks ~/.berkshelf/ /.chef ; sudo bash -x /usr/src/raspberry-bitcoin/bootstrap.sh
```


OLD STUFF

# network configuration
cat << EOF >/etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet manual
#    metric 0

allow-hotplug wlan0
iface wlan0 inet manual
#    metric 1
	wpa-roam /etc/wpa_supplicant/wpa_supplicant.conf

iface default inet static
	address 192.168.1.200
	network 192.168.1.0
	netmask 255.255.255.0
	broadcast 192.168.1.255
	gateway 192.168.1.1
EOF
```

```
# tell the wpa_supplicant to reconfigure itself
cat << EOF >/etc/wpa_supplicant/wpa_supplicant.conf
network={
ssid="NETGEAR"
psk="SeCrEt"
proto=RSN
key_mgmt=WPA-PSK
pairwise=CCMP
auth_alg=OPEN
}
EOF
```

```bash
# Optimize / mount
#sed -i 's/defaults,noatime/defaults,noatime,nodiratime/g' /etc/fstab

# Disable IPv6
echo "net.ipv6.conf.all.disable_ipv6=1" > /etc/sysctl.d/disableipv6.conf
echo 'blacklist ipv6' >> /etc/modprobe.d/blacklist
sed -i '/::/s%^%#%g' /etc/hosts

# compile zram module
# zram: https://github.com/raspberrypi/linux/issues/179#issuecomment-14164706
apt-get -y install linux-headers-rpi-rpfv

# drop the zram script
cat << EOF >/etc/init.d/zram
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

# start on boot disable, rpi official firmware is missing the zram module
# update-rc.d zram defaults

# done, reboot
reboot
```

6) Install CGMiner 
```bash
# install building dependencies
apt-get -y install libusb-1.0-0-dev libusb-1.0-0 libcurl4-openssl-dev libncurses5-dev libudev-dev

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
```

7) Install adafruit goodies

7.1) Adafruit GPIO: https://learn.adafruit.com/adafruits-raspberry-pi-lesson-4-gpio-setup

7.2) Adafruit 16x2 Character LCD: https://learn.adafruit.com/adafruit-16x2-character-lcd-plus-keypad-for-raspberry-pi/overview

7.3) Install PiMiner
```bash
cd /usr/src
git clone https://github.com/adafruit/PiMiner.git
```

8) Monitoring
```bash
cd /usr/src
# install google python library
wget https://gdata-python-client.googlecode.com/files/gdata-2.0.18.tar.gz
tar xvf gdata-2.0.18.tar.gz
cd gdata-2.0.18
python setup.py install
python tests/run_data_tests.py
vi samples/docs/docs_example.py

python tests/run_data_tests.py
vi samples/docs/docs_example.py
```

9) Auto-start on boot.
   Make your /etc/rc.local look something like this:
```bash
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
	
	cd /usr/src/PiMiner
	python PiMiner.py &
	nohup /usr/src/cgminer/cgminer --config /etc/cgminer.conf >/dev/null 2>&1&
	
	exit 0
```


Firewall rules
--------------

Don't forget to forward TCP/8333 internet traffic to the Raspberry Pi.


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


Contributing and Development
----------------------------

Bugs and PRs are welcome!
I code and test with vagrant, then I test on a fresh raspberry pi.
