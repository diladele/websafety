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

# download
wget http://packages.diladele.com/websafety/$MAJOR.$MINOR/$ARCH/release/ubuntu18/websafety-$MAJOR.${MINOR}_$ARCH.deb

# install
dpkg --install websafety-$MAJOR.${MINOR}_$ARCH.deb

# generate the configuration files once
sudo -u websafety python3 /opt/websafety/var/console/generate.py

# relabel folder
chown -R websafety:websafety /opt/websafety

# fix the tld error (see https://github.com/diladele/websafety-issues/issues/1112)
sudo -u websafety patch /opt/websafety/var/console/_domain/traffic/users.py < users.py.patch
