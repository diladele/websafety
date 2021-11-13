#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# default arc
MAJOR="8.0.0"
MINOR="8D59"

# get latest build
curl -O https://packages.diladele.com/websafety-core/$MAJOR.$MINOR/amd64/release/redhat8/websafety-${MAJOR}-${MINOR}.x86_64.rpm

# and install it
dnf -y install websafety-${MAJOR}-${MINOR}.x86_64.rpm

# web safety runs using the same user as squid
chown -R squid:squid /opt/websafety
