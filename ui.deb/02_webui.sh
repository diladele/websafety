#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# default arch and version
MAJOR="7.7.0"
MINOR="2861"
ARCH="amd64"

# default os
OSNAME="debian11"
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

# integrate with apache
a2dissite 000-default
a2ensite websafety

# and restart all daemons
service apache2 restart
