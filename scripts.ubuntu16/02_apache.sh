#!/bin/bash

# all web packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# install pip3
apt -y install python3-pip 

# install django and all other modules
pip3 install django==1.11.13
pip3 install ldap
pip3 install pytz
pip3 install requests
pip3 install pandas
pip3 install PyYAML

# to have PDF reports we need to install reportlab with a lot of dependencies
apt -y install python3-dev libjpeg-dev zlib1g-dev htop

# now install reportlab
pip3 install reportlab==3.4.0

# install apache and mod_wsgi
apt -y install apache2 libapache2-mod-wsgi-py3

# install kerberos client libraries
export DEBIAN_FRONTEND=noninteractive 
apt -y install krb5-user
