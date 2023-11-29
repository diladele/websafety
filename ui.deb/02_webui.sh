#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# default arch and version
MAJOR="9.0.0"
MINOR="E780"
ARCH="amd64"

# default os
OSNAME="debian12"
if [ -f "/etc/lsb-release" ]; then
    OSNAME="ubuntu22"
fi

# download
wget https://packages.diladele.com/websafety-ui/$MAJOR.$MINOR/$ARCH/release/$OSNAME/websafety-ui-$MAJOR.${MINOR}_$ARCH.deb

# install
dpkg --install websafety-ui-$MAJOR.${MINOR}_$ARCH.deb
