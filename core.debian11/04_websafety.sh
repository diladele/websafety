#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# default arc
MAJOR="8.1.0"
MINOR="291A"
ARCH="amd64"

# get latest build
cat /proc/cpuinfo | grep -m 1 ARMv7 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    ARCH="armhf"
fi

wget https://packages.diladele.com/websafety-core/$MAJOR.$MINOR/$ARCH/release/debian11/websafety-$MAJOR.${MINOR}_$ARCH.deb

# install it
dpkg --install websafety-$MAJOR.${MINOR}_$ARCH.deb

# web safety runs using the same user as squid
chown -R proxy:proxy /opt/websafety
