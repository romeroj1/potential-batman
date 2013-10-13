#!/bin/bash

#########
#
# This scripts reloads the firware for the broadcom wireless NIC
#  4312
#
#
################

sudo yum -y install b43-fwcutter wget

cd ~/Downloads/
wget http://downloads.openwrt.org/sources/broadcom-wl-4.150.10.5.tar.bz2
tar -xjvf broadcom-wl-4.150.10.5.tar.bz2
cd broadcom-wl-4.150.10.5/driver
sudo 43-fwcutter -w /lib/firmware/ wl_apsta_mimo.o
sudo modprobe -r b43
sudo modprobe b43
