#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Admin UI now runs using HTTPS so to integrate with apache, we need to enable the HTTPS
a2enmod ssl

# disable the default site and enable web safety
a2dissite 000-default
a2ensite websafety

# finally restart all daemons
service apache2 restart
