#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# default params
MAJOR="7.2.0"
MINOR="56AA"
ARCH="amd64"
OSNAME="centos8"

# download
curl -O http://packages.diladele.com/websafety-ui/$MAJOR.$MINOR/$ARCH/release/centos8/websafety-ui-${MAJOR}-${MINOR}.x86_64.rpm

# install
dnf -y install websafety-ui-${MAJOR}-${MINOR}.x86_64.rpm

# sync ui and actual files in disk
sudo -u squid python3 /opt/websafety-ui/var/console/generate.py

# relabel folder
chown -R websafety:websafety /opt/websafety-ui

# and restart all daemons
systemctl restart httpd
