#!/bin/bash

# check we are root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# stop immediately on any error
set -e

# install clamav
apt-get -y install clamav
apt-get -y install clamav-daemon

# install c-icap
apt-get -y install c-icap
apt-get -y install libicapapi-dev

# drop build folder for squidclamav
rm -R build/squidclamav 2>&1 > /dev/null || true 

# make build folder
mkdir -p build/squidclamav

# decend into working directory
pushd build/squidclamav

# get it
wget http://downloads.sourceforge.net/project/squidclamav/squidclamav/6.16/squidclamav-6.16.tar.gz \
	&& gunzip squidclamav-6.16.tar.gz \
	&& tar -xvf squidclamav-6.16.tar

# configure and build the package
cd squidclamav-6.16 && ./configure --with-c-icap=/usr && make 

# install it
make install

# revert
popd

# 
echo
echo
echo SUCCESS: squidclamav module is built and installed successfully!
echo SUCCESS: now run 02_configure.sh script to perform initial configuration.
echo
echo 
