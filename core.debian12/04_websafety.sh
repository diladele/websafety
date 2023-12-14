#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# default arc
MAJOR="9.0.0"
MINOR="7CE1"
ARCH="amd64"

# get latest build
cat /proc/cpuinfo | grep -m 1 ARMv7 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    ARCH="armhf"
fi

wget https://packages.diladele.com/websafety-core/$MAJOR.$MINOR/$ARCH/release/debian12/websafety-$MAJOR.${MINOR}_$ARCH.deb

# install it
dpkg --install websafety-$MAJOR.${MINOR}_$ARCH.deb

# for the authenticated portal to work we need to show our own deny info for 511 requests
# due to the bug in squid it thinks the path start in templates not on / 
mkdir -p /usr/share/squid/errors/templates/opt/websafety/etc/squid

# so we make a link to trick it 
ln -s /opt/websafety/etc/squid/portal.html /usr/share/squid/errors/templates/opt/websafety/etc/squid/portal.html

# web safety runs using the same user as squid
chown -R proxy:proxy /opt/websafety
