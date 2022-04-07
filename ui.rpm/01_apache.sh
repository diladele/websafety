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

# install python 3 development libs
dnf -y install python3-devel redhat-rpm-config

# rust is required for PyOpenSSL
dnf -y module install rust-toolset

# install python django for web ui
pip3 install django==3.2.11
pip3 install pytz
pip3 install tld
pip3 install requests
pip3 install pandas
pip3 install PyYAML
pip3 install setuptools-rust
pip3 install PyOpenSSL
pip3 install psutil
pip3 install python-ldap
pip3 install mod-wsgi
pip3 install jinja2
pip3 install msal

# enable the mod_wsgi module for python3 in apache
/usr/local/bin/mod_wsgi-express install-module > /etc/httpd/conf.modules.d/02-wsgi.conf

# disable default HTTP and HTTPS sites
mv /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/welcome.conf.original
mv /etc/httpd/conf.d/ssl.conf /etc/httpd/conf.d/ssl.conf.original

# and restart apache
systemctl restart httpd

# allow connection to 80, 443 and 3128 ports for apache and squid
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --reload
