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
