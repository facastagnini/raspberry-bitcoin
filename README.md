Raspberry-Bitcoin
=================

Build a full node + miner for a Raspberry Pi B.


Installation
------------

 - Install Raspbian on a 16Gb or bigger SD card. (There is a guide here http://www.raspberrypi.org/documentation/installation/installing-images/README.md)

 - Build the full node.
   A full node is bla bla bla and provides this this and this and help Bitcoin in this way.
   Since the Raspbian repositories host an archaic version of Bitcoin Core (the original Bitcoin client), we will have to compile from source.

	apt-get update
	apt-get dist-upgrade


CREDIT: I based this part of the instruccions from this excelent article -> http://blog.pryds.eu/2014/06/compile-bitcoin-core-on-raspberry-pi.html

Firewall rules
--------------

Don't forget to forward traffic on port 8333 to the Raspberry Pi.


ASIC USB miner
--------------

I am using BITMAIN ANTMINER U2+ ASIC Bitcoin Miner (http://www.amazon.com/gp/product/B00JT3HMRI)

antminer_clock_settings:
0781 = 1.6 Ghps
0881 = 1.8 Ghps
0981 = 2.0 Ghps
0A01 = 2.1 Ghps
0A81 = 2.2 Ghps
0B01 = 2.3 Ghps
0B81 = 2.4 Ghps
