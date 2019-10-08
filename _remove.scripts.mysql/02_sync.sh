#!/bin/bash

# we must be root to install packages
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# create special 'websafety' user in mysql with superuser rights
mysql -u root mysql < websafety.sql

# create the database (all mysql specific settings are taken from settings.py)
python3 /opt/websafety/var/console/switch_db.py --db=mysql

# generate the monitor.json in /opt/websafety/etc/ with new correct database settings
python3 /opt/websafety/var/console/sync_db.py

# reset the owner
chown -R websafety:websafety /opt/websafety

# restart django and wsmgrd
systemctl restart wsmgrd

if [ -f /etc/centos-release ] || [ -f /etc/redhat-release ]; then
	systemctl restart httpd
else 
	systemctl restart apache2
fi

