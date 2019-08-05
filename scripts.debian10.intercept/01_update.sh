#!/bin/bash

# update should be done as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# remove unneeded packages
apt -y autoremove

# update and upgrade
apt-get update && apt-get -y upgrade

# and now reboot
reboot