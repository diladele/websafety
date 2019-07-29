#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# install clamav
apt-get install -y clamav clamav-daemon libclamav-dev

# we will be working in a subfolder
rm -R ./build/ecap_clamav
mkdir -p ./build/ecap_clamav

# change into the folder
pushd ./build/ecap_clamav

# from now on every error is fatal
set -e

# download the sources
wget http://www.e-cap.org/archive/ecap_clamav_adapter-2.0.0.tar.gz

# unpack and untar them
gunzip ecap_clamav_adapter-2.0.0.tar.gz
tar -xvf ecap_clamav_adapter-2.0.0.tar

# change working dir
pushd ecap_clamav_adapter-2.0.0

# configure
./configure

# patch the CL_SCAN_STDOPT error
patch patch /etc/default/c-icap < ClamAv.cc.patch

# make 
make && make install

# revert back
popd

# and again
popd
