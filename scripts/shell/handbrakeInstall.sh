#!/bin/bash

sudo yum -y groupinstall "Development Tools"
sudo yum -y install yasm zlib-devel bzip2-devel fribidi-devel dbus-glib-devel libgudev1-devel webkitgtk-devel libnotify-devel gstreamer-devel gstreamer-plugins-base-devel libsamplerate-devel libtheora-devel libass-devel libvorbis-devel
svn checkout svn://svn.handbrake.fr/HandBrake/trunk hb-trunk
cd hb-trunk
./configure
cd build
gmake
make install
