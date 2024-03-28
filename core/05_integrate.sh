#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# install required system packages
apt -y install cron htop mc net-tools jq vim

# replace the squid config
if [ ! -f /etc/squid/squid.conf.default ]; then
    cp -f /etc/squid/squid.conf /etc/squid/squid.conf.default
fi
cp -f squid.conf /etc/squid/squid.conf

# re-initialize storage for mimicked ssl certificates
SSL_DB=/var/spool/squid/ssldb
if [ -d $SSL_DB ]; then
	rm -Rf $SSL_DB
fi
/usr/lib/squid/security_file_certgen -c -s $SSL_DB -M 4MB
if [ $? -ne 0 ]; then
    echo "Error $? while initializing SSL certificate storage, exiting..."
    exit 1
fi

# relabel folder and logs
chown -R proxy:proxy $SSL_DB
chown -R proxy:proxy /var/log/squid

# and restart all daemons
systemctl start wsicapd && service squid restart
