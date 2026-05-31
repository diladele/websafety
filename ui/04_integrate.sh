#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# disable the default nginx site
rm /etc/nginx/sites-enabled/default

# and enable web safety instead
ln -s /etc/nginx/sites-available/websafety /etc/nginx/sites-enabled/websafety

# finally restart all daemons
service nginx restart
service gunicorn restart
