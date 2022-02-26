#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# install clamav
apt-get install -y clamav clamav-daemon libclamav-dev g++ make pkg-config

# from now on every error is fatal
set -e

# download the sources
wget https://www.e-cap.org/archive/ecap_clamav_adapter-2.0.0.tar.gz

# unpack
tar -xvzf ecap_clamav_adapter-2.0.0.tar.gz

# patch the CL_SCAN_STDOPT error
patch ecap_clamav_adapter-2.0.0/src/ClamAv.cc < ClamAv.cc.patch

# change into working dir
pushd ecap_clamav_adapter-2.0.0

# build
./configure && make && make install

# revert back
popd
