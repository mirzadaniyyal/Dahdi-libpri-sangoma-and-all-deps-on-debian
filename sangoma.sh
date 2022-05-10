#!/bin/bash

DA='dahdi-linux-complete-2.5.0.1+2.5.0.1'
WAN="wanpipe-3.5.23"
PRI="libpri-1.4.12"

apt-get -y install build-essential
apt-get -y install gcc
apt-get -y install g++
apt-get -y install automake
apt-get -y install autoconf
apt-get -y install libtool
apt-get -y install make
apt-get -y install libncurses5-dev
apt-get -y install flex
apt-get -y install bison
apt-get -y install patch
apt-get -y install libtool
apt-get -y install linux-source-$(uname -r)
apt-get -y install linux-headers-$(uname -r)
apt-get -y install libsctp-dev
apt-get -y install libtool

cd /usr/src 

## GET FILES
wget http://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/releases/${DA}.tar.gz
wget http://downloads.asterisk.org/pub/telephony/libpri/releases/${PRI}.tar.gz
wget ftp://ftp.sangoma.com/linux/current_wanpipe/${WAN}.tgz

sleep 5

# DECOMPRESS FILES
tar -zxvf ${DA}.tar.gz 
tar -zxvf ${PRI}.tar.gz 
tar xvfz ${WAN}.tgz 

sleep 5

# COMPILE DAHDI
cd /usr/src/${DA}
make all && make install & make config
cd ..

sleep 5

# COMPILE LIBPRI
cd /usr/src/${PRI}
make && make install
cd ..
sleep 5

# COMPILE & CONFIG WANPIPE
cd /usr/src/${WAN}
./Setup dahdi

# RESTARTS
wanrouter stop
wanrouter start
/etc/init.d/asterisk stop
dahdi_cfg
/etc/init.d/asterisk start

# CHECK ASTERISK
asterisk -rx 'dahdi show channels'

exit 0
