#!/bin/bash

# all web packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# install pip3 and other python modules, ldap/sasl (we need it for python ldap module)
apt -y install python3-pip python3-dev libjpeg-dev zlib1g-dev libldap2-dev libsasl2-dev libssl-dev

# install django and all other modules
pip3 install django==2.1.2
pip3 install pytz
pip3 install requests
pip3 install pandas
pip3 install PyYAML

# there are some bugs in Ubuntu 18 and Python3 environment concerning the LDAP module,
# so we fix them by removing obsolete ldap modules and reinstalling the correct one
pip3 uninstall ldap
pip3 uninstall ldap3
pip3 uninstall python-ldap

# ok this one is fine
pip3 install python-ldap

# now install reportlab
pip3 install reportlab==3.4.0

# install apache and mod_wsgi and some other useful programs
apt -y install apache2 libapache2-mod-wsgi-py3 htop mc

# install kerberos client libraries
export DEBIAN_FRONTEND=noninteractive 
apt -y install krb5-user
