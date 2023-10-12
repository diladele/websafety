#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# default arc
MAJOR="8.7.0"
MINOR="6756"

# get latest build
curl -O https://packages.diladele.com/websafety-core/$MAJOR.$MINOR/amd64/release/redhat9/websafety-${MAJOR}-${MINOR}.x86_64.rpm

# and install it
dnf -y install websafety-${MAJOR}-${MINOR}.x86_64.rpm

# web safety runs using the same user as squid
chown -R squid:squid /opt/websafety

# for the authenticated portal to work we need to show our own deny info for 511 requests
# due to the bug in squid it thinks the path start in templates not on / 
mkdir -p /usr/share/squid/errors/templates/opt/websafety/etc/squid

# so we make a link to trick it 
ln -s /opt/websafety/etc/squid/portal.html /usr/share/squid/errors/templates/opt/websafety/etc/squid/portal.html
