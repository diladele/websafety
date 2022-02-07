#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# install web safety core daemons
MAJOR="8.0.0"
MINOR="03D9"
ARCH="amd64"

# download
wget https://packages.diladele.com/websafety-core/$MAJOR.$MINOR/$ARCH/release/ubuntu20/websafety-$MAJOR.${MINOR}_$ARCH.deb

# install
dpkg --install websafety-$MAJOR.${MINOR}_$ARCH.deb

# web safety runs using the same user as squid
chown -R proxy:proxy /opt/websafety
