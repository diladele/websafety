#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# we need epel release for clamav
dnf -y install epel-release

# install clamav
dnf -y install clamav clamav-update clamav-devel gcc-c++ patch make

# from now on every error is fatal
set -e

# download the sources
curl -O http://www.e-cap.org/archive/ecap_clamav_adapter-2.0.0.tar.gz

# unpack
tar -xvzf ecap_clamav_adapter-2.0.0.tar.gz

# patch the CL_SCAN_STDOPT error
patch ecap_clamav_adapter-2.0.0/src/ClamAv.cc < ClamAv.cc.patch

# change into working dir
pushd ecap_clamav_adapter-2.0.0

# configure, make and install
./configure && make && make install

# and revert back
popd
