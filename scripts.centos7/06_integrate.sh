#!/bin/bash

# integration should be done as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# allow connection to 80, 443 and 3128 ports for apache and squid
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --permanent --zone=public --add-port=3128/tcp
firewall-cmd --reload

# adjust the squid.conf
if [ ! -f /etc/squid/squid.conf.original ]; then
    mv /etc/squid/squid.conf /etc/squid/squid.conf.original
fi

# copy new config
cp squid.conf /etc/squid/squid.conf

# allow web ui read-only access to squid configuration file
chmod o+r /etc/squid/squid.conf

# create storage for generated ssl certificates
SSL_DB=/var/spool/squid_ssldb
if [ -d $SSL_DB ]; then
	rm -Rf $SSL_DB
fi

/usr/lib64/squid/security_file_certgen -c -s $SSL_DB -M 4MB

# and change its ownership
chown -R squid:squid $SSL_DB

# parse the resulting config just to be sure
/usr/sbin/squid -k parse

# restart squid to load all config
systemctl restart squid.service
