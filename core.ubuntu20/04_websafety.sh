#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# install web safety core daemons
MAJOR="8.5.0"
MINOR="5846"
ARCH="amd64"

# download
wget https://packages.diladele.com/websafety-core/$MAJOR.$MINOR/$ARCH/release/ubuntu20/websafety-$MAJOR.${MINOR}_$ARCH.deb

# install
dpkg --install websafety-$MAJOR.${MINOR}_$ARCH.deb

# for the authenticated portal to work we need to show our own deny info for 511 requests
# due to the bug in squid it thinks the path start in templates not on / 
mkdir -p /usr/share/squid/errors/templates/opt/websafety/etc/squid

# so we make a link to trick it 
ln -s /opt/websafety/etc/squid/portal.html /usr/share/squid/errors/templates/opt/websafety/etc/squid/portal.html

# web safety runs using the same user as squid
chown -R proxy:proxy /opt/websafety
