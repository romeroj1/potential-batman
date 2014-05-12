#!/bin/bash

sudo rpm -ivh http://linuxdownload.adobe.com/adobe-release/adobe-release-i386-1.0-1.noarch.rpm
sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux
sudo "curl http://download.opensuse.org/repositories/home:/satya164:/fedorautils/Fedora_18/home:satya164:fedorautils.repo -o /etc/yum.repos.d/fedorautils.repo"
sudo "curl http://download.opensuse.org/repositories/home:/satya164:/fedorautils/Fedora_18/home:satya164:fedorautils.repo -o /etc/yum.repos.d/fedorautils.repo"
sudo yum -y localinstall --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-18.noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-18.noarch.rpm

sudo yum -y update
sudo yum -y update kernel
sudo yum -y install gnome-tweak-tool gstreamer gstreamer-ffmpeg gstreamer-plugins-bad gstreamer-plugins-bad-free gstreamer-plugins-bad-nonfree 
gstreamer-plugins-base gstreamer-plugins-good gstreamer-plugins-ugly ffmpeg vlc 
flash-plugin java-*-openjdk java-*-openjdk-plugin gimp inkscape blender filezilla gwibber unrar p7zip p7zip-plugins 
yumex nfs-utils python-pip python2-devel fedorautils eclipse wireshark-gnome dd_rescue kmod-wl openvpn dkms

sudo yum -y telnet wget kernel-devel kernel-headers gcc gcc-c++ sysstat

sudo yum -y groupinstall 'Development Tools'



wget http://download.virtualbox.org/virtualbox/4.3.10/VBoxGuestAdditions_4.3.10.iso