#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# default arch and version
MAJOR="8.1.0"
MINOR="EC4A"
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

# Admin UI now runs using HTTPS so to integrate with apache, first enable the HTTPS module
a2enmod ssl

# then generate the self signed certificates valid for next 5 years
sudo -u websafety openssl \
    req -x509 -nodes -days 1825 -newkey rsa:2048 \
    -keyout /opt/websafety-ui/etc/admin_ui.key \
    -out /opt/websafety-ui/etc/admin_ui.crt \
    -subj "/C=NL/ST=Noord-Holland/O=Example Ltd./OU=IT/CN=proxy.example.lan/emailAddress=support@example.lan"

# disable the default site
a2dissite 000-default

# and enable web safety
a2ensite websafety

# finally restart all daemons
service apache2 restart
