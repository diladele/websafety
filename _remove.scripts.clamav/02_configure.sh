#!/bin/bash

# check we are root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# patch /etc/default/c-icap (make c-icap autostart)
if [ ! -f /etc/default/c-icap.default ]; then
    cp -f /etc/default/c-icap /etc/default/c-icap.default
fi
patch /etc/default/c-icap < c-icap.patch

# patch settings in c-icap.conf (enable squidclamav)
if [ ! -f /etc/c-icap/c-icap.conf.default ]; then
    cp -f /etc/c-icap/c-icap.conf /etc/c-icap/c-icap.conf.default
fi
patch /etc/c-icap/c-icap.conf < c-icap.conf.patch

# patch settings in squidclamav.conf (disable redirect and DNS lookup)
if [ ! -f /etc/c-icap/squidclamav.conf.default ]; then
    cp -f /etc/c-icap/squidclamav.conf /etc/c-icap/squidclamav.conf.default
fi
patch /etc/c-icap/squidclamav.conf < squidclamav.conf.patch

# good now restart all related services
systemctl stop clamav-daemon
systemctl stop c-icap

systemctl start clamav-daemon
systemctl start c-icap


# check status (must be running)
systemctl status clamav-daemon
systemctl status c-icap

# 
echo
echo
echo SUCCESS: squidclamav module is configured successfully!
echo SUCCESS: now change ICAP integration settings in Web Safety Web UI
echo SUCCESS: Squid / ICAP / Integration. Set AV port to 1345 and
echo SUCCESS: REQMOD/RESPMOD paths to squidclamav
echo
echo 
