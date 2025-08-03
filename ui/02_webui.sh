#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# default arch and version
MAJOR="9.6.0"
MINOR="43AA"
ARCH="amd64"

# download
wget https://packages.diladele.com/websafety-ui/$MAJOR.$MINOR/$ARCH/release/ubuntu24/websafety-ui-$MAJOR.${MINOR}_$ARCH.deb

# install
dpkg --install websafety-ui-$MAJOR.${MINOR}_$ARCH.deb
