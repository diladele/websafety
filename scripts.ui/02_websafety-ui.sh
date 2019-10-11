#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# default arc
MAJOR="7.2.0"
MINOR="F931"
ARCH="amd64"

# download
wget http://packages.diladele.com/websafety-ui/$MAJOR.$MINOR/$ARCH/release/ubuntu18/websafety-ui-$MAJOR.${MINOR}_$ARCH.deb

# install
dpkg --install websafety-ui-$MAJOR.${MINOR}_$ARCH.deb

# generate the configuration files once as the proxy user
sudo -u proxy python3 /opt/websafety-ui/var/console/generate.py

# and relabel folder
chown -R websafety:websafety /opt/websafety-ui
