#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# disable default HTTP and HTTPS sites
mv /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/welcome.conf.original
mv /etc/httpd/conf.d/ssl.conf /etc/httpd/conf.d/ssl.conf.original

# and restart all daemons
systemctl restart httpd

# allow connection to 80, 443 and 3128 ports for apache and squid
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --reload
