#!/bin/bash

# all web packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# install pip3 and other python modules, ldap/sasl (we need it for python ldap module)
# apt -y install python3-pip python3-dev libjpeg-dev zlib1g-dev libldap2-dev libsasl2-dev libssl-dev 

# on RPI install libatlas for numpy
# cat /proc/cpuinfo | grep -m 1 ARMv7 > /dev/null 2>&1
# if [ $? -eq 0 ]; then
#    apt-get install libatlas-base-dev
#fi

# install apache and mod_wsgi and some other useful programs
apt -y install apache2 libapache2-mod-wsgi-py3 htop mc net-tools

# install kerberos client libraries
export DEBIAN_FRONTEND=noninteractive 
apt -y install krb5-user
