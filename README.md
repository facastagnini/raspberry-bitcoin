Raspberry-Bitcoin
=================

[![Build Status](http://img.shields.io/travis/facastagnini/raspberry-bitcoin.svg)](http://travis-ci.org/facastagnini/raspberry-bitcoin)
[![Dependencies](http://img.shields.io/gemnasium/facastagnini/raspberry-bitcoin.svg)](https://gemnasium.com/facastagnini/raspberry-bitcoin)

This is an attempt to build a full bitcoin node on a Raspberry Pi 2 B (4 cores, 1GB ram).
It is NOT possible to run a full node on the raspberry pi 1 B. Not enought CPU, neither RAM.


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


OLD STUFF not yet implemented in chef

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

Firewall rules
--------------

Don't forget to forward TCP/8333 internet traffic to the Raspberry Pi.

Contributing and Development
----------------------------

Bugs and PRs are welcome!
I code and test with vagrant, then I test on a fresh raspberry pi.
