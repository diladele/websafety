#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# default arch and version
MAJOR="9.8.0"
MINOR="18A1"
ARCH="amd64"

# download
wget https://www.diladele.com/pkg/websafety-ui/$MAJOR.$MINOR/$ARCH/release/ubuntu26/websafety-ui-$MAJOR.${MINOR}_$ARCH.deb

# install
dpkg --install websafety-ui-$MAJOR.${MINOR}_$ARCH.deb
