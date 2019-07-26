#!/bin/csh

# add apache
pkg install -y apache24 ap24-py36-mod_wsgi

# add python
pkg install -y python3 sqlite3 py36-sqlite3 py36-ldap py36-openssl

# install pip
python3 -m ensurepip

pip3 install django==2.1.2
pip3 install requests
pip3 install numpy
pip3 install pandas
pip3 install PyYAML

# add other important modules
pkg install -y openldap-client sudo ca_root_nss

# autostart apache
grep -e '^\s*apache24_enable\s*=\s*\"YES\"\s*$' /etc/rc.conf
if [ $? -ne 0 ]; then
    echo "apache24_enable=\"YES\"" >> /etc/rc.conf
fi
