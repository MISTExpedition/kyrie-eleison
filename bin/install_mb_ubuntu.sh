#!/bin/bash

START_DIR=${PWD}
SOURCE=${HOME}/src/mist

# Install the depedencies
echo "Installing dependencies"
sudo apt-get install gfortran libnetcdf-dev gmt libgmt-dev libfftw3-dev libxt-dev libmotif-dev mesa-common-dev freeglut3-dev

# Download the software
echo "Making source directory: ${SOURCE}"
mkdir -p ${SOURCE}
cd ${SOURCE}

echo "Downloading MB System"

if [ ! -f MB-System.tar.gz ]; then
	echo "Downloading MB-System"
	wget "ftp://ftp.ldeo.columbia.edu/pub/MB-System/MB-System.tar.gz"
fi
if [ ! -f annual.gz]; then
	echo "Downloading annual.gz"
wget "ftp://ftp.ldeo.columbia.edu/pub/MB-System/annual.gz"
fi
if [ ! -f OTPSnc.tar.Z ]; then
	echo "Downloading OTPSnc"
	wget "ftp://ftp.oce.orst.edu/dist/tides/OTPSnc.tar.Z"
fi
if [ ! -f sioseis-2013.2.3.tar.bz2 ]; then
	echo "Downloading SIOSeis"
	wget "http://sioseis.ucsd.edu/src/sioseis-2013.2.3.tar.bz2"
fi

# Expand the software
tar -xvf MB-System.tar.gz
tar -xvf OTPSnc.tar.Z

# Build MB-System
cd ${SOURCE}/mbsystem-*/
./configure --with-gmt-include=/usr/include/gmt
make
sudo make install

# Build OTPSnc
cd ${SOURCE}/OTPSnc
# Patch the makefile to read thus:
patch << EOF
--- makefile.orig	2013-09-30 12:05:47.562490937 -0700
+++ makefile	2013-09-30 12:15:52.662472549 -0700
@@ -6,9 +6,9 @@
 endif
 ifeq (\$(ARCH),Linux)
  FC = gfortran #pgf90
- NCLIB = /usr/local/netcdf4/lib
- NCINCLUDE = /usr/local/include
- NCLIBS= -lnetcdf
+ NCLIB = /usr/lib
+ NCINCLUDE = /usr/include
+ NCLIBS= -lnetcdff
 endif
 
 predict_tide: predict_tide.f subs.f constit.h
EOF
make predict_tide extract_HC
sudo mkdir -p /usr/local/OTPSnc
sudo cp predict_tide extract_HC /usr/local/OTPSnc

cd ${START_DIR}



