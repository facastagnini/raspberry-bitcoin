Raspberry-Bitcoin
=================

Build a full node + miner with a Raspberry Pi B.


Installation
------------

1) Install Raspbian on a 16Gb or bigger SD card. (There is a guide here http://www.raspberrypi.org/documentation/installation/installing-images/README.md)

2) Clone this git repo.

	apt-get update
	apt-get install git
	cd /root
	git clone git@github.com:facastagnini/raspberry-bitcoin.git


3) Setup the full node.
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
	mkdir /root/bitcoin
	ln /root/raspberry-bitcoin/bitcoin.conf /root/.bitcoin/bitcoin.conf
	
	# start the bitcoin daemon
	/usr/local/bin/bitcoind -conf=/root/.bitcoin/bitcoin.conf


Bitcoind will connect to some peers and start downloading the blockchain. You can monitor the progress with the folowing command:

	bitcoind getinfo

CREDIT: I based this part of the instruccions on this excelent article -> http://blog.pryds.eu/2014/06/compile-bitcoin-core-on-raspberry-pi.html

4) Install CGMiner


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
