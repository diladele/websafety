#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# default arch and version
MAJOR="8.6.0"
MINOR="672B"
ARCH="amd64"

# default os
OSNAME="debian12"
if [ -f "/etc/lsb-release" ]; then
    OSNAME="ubuntu20"
fi

# download
wget https://packages.diladele.com/websafety-ui/$MAJOR.$MINOR/$ARCH/release/$OSNAME/websafety-ui-$MAJOR.${MINOR}_$ARCH.deb

# install
dpkg --install websafety-ui-$MAJOR.${MINOR}_$ARCH.deb

# sync ui and actual files in disk (note UI does not manage network by default)
sudo -u proxy python3 /opt/websafety-ui/var/console/generate.py --core
sudo -u websafety python3 /opt/websafety-ui/var/console/generate.py --ui

# relabel folder
chown -R websafety:websafety /opt/websafety-ui

# Admin UI now runs using HTTPS so to integrate with apache, we need to enable the HTTPS
a2enmod ssl

# disable the default site and enable web safety
a2dissite 000-default
a2ensite websafety

# finally restart all daemons
service apache2 restart
