#!/bin/bash

# all web packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# we are running non interactive
export DEBIAN_FRONTEND=noninteractive 

# install nginx and kerberos client libraries
apt -y install nginx krb5-user

# install apache and mod_wsgi and some other useful programs
# apt -y install apache2 libapache2-mod-wsgi-py3

# create the override folder for apache
# mkdir -p /etc/systemd/system/apache2.service.d/

# override security defaults for Apache introduced in Ubuntu 26.04
# cat >/etc/systemd/system/apache2.service.d/override.conf << EOL
# [Service]
# ProcSubset=all
# EOL
