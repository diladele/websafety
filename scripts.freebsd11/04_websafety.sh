#!/bin/csh

# setup some configuration variables
ARCH=`uname -m`
DDWS_VERSION=7.0.0
DDWS_BUILD=7A5E

# get latest version of web safety
fetch http://packages.diladele.com/websafety/$DDWS_VERSION.$DDWS_BUILD/$ARCH/release/freebsd11/websafety-$DDWS_VERSION-$ARCH.txz

# and install it
env ASSUME_ALWAYS_YES=YES pkg install -y websafety-$DDWS_VERSION-$ARCH.txz

# autostart ICAP server
grep -e '^\s*wsicapd_enable\s*=\s*\"YES\"\s*$' /etc/rc.conf
if [ $? -ne 0 ]; then
    echo "wsicapd_enable=\"YES\"" >> /etc/rc.conf
fi

# autostart monitoring server
grep -e '^\s*wsmgrd_enable\s*=\s*\"YES\"\s*$' /etc/rc.conf
if [ $? -ne 0 ]; then
    echo "wsmgrd_enable=\"YES\"" >> /etc/rc.conf
fi

# autostart sync server
grep -e '^\s*wssyncd_enable\s*=\s*\"YES\"\s*$' /etc/rc.conf
if [ $? -ne 0 ]; then
    echo "wssyncd_enable=\"YES\"" >> /etc/rc.conf
fi

# autostart google safe browsing server
grep -e '^\s*wsgsbd_enable\s*=\s*\"YES\"\s*$' /etc/rc.conf
if [ $? -ne 0 ]; then
    echo "wsgsbd_enable=\"YES\"" >> /etc/rc.conf
fi

# autostart youtube guard daemon
grep -e '^\s*wsytgd_enable\s*=\s*\"YES\"\s*$' /etc/rc.conf
if [ $? -ne 0 ]; then
    echo "wsytgd_enable=\"YES\"" >> /etc/rc.conf
fi

# generate the configuration files once
sudo -u websafety python3 /opt/websafety/var/console/generate.py

# relabel folder
chown -R websafety:websafety /opt/websafety