#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# default arch and version
MAJOR="7.3.0"
MINOR="8476"
ARCH="amd64"

# default os
OSNAME="debian10"
if [ -f "/etc/lsb-release" ]; then
    OSNAME="ubuntu18"
fi

# download
wget http://packages.diladele.com/websafety-ui/$MAJOR.$MINOR/$ARCH/release/$OSNAME/websafety-ui-$MAJOR.${MINOR}_$ARCH.deb

# install
dpkg --install websafety-ui-$MAJOR.${MINOR}_$ARCH.deb

# let ui to manage the network
sudo -u websafety python3 /opt/websafety-ui/var/console/utils.py --network=$OSNAME

# sync ui and actual files in disk
sudo -u proxy python3 /opt/websafety-ui/var/console/generate.py --core
sudo -u websafety python3 /opt/websafety-ui/var/console/generate.py --ui

# relabel folder
chown -R websafety:websafety /opt/websafety-ui

# integrate with apache
a2dissite 000-default
a2ensite websafety

# and restart all daemons
service apache2 restart
