#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# default arc
MAJOR="7.0.0"
MINOR="7A5E"
ARCH="amd64"

# get latest build
cat /proc/cpuinfo | grep -m 1 ARMv7 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    ARCH="armhf"
fi

wget http://packages.diladele.com/websafety/$MAJOR.$MINOR/$ARCH/release/debian9/websafety-$MAJOR.${MINOR}_$ARCH.deb

# install it
dpkg --install websafety-$MAJOR.${MINOR}_$ARCH.deb

# generate the configuration files once
sudo -u websafety python3 /opt/websafety/var/console/generate.py

# relabel folder
chown -R websafety:websafety /opt/websafety