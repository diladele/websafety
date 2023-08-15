#!/bin/bash

# all web packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# install apache web server
dnf -y install httpd httpd-devel mod_ssl openssl

# make apache autostart on reboot
systemctl enable httpd

# enable the mod_wsgi module for python3 in apache
/usr/local/bin/mod_wsgi-express install-module > /etc/httpd/conf.modules.d/02-wsgi.conf
