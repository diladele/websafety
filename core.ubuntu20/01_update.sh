#!/bin/bash

# update should be done as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# add universe repo
add-apt-repository universe

# update and upgrade
apt update && apt -y upgrade

# and now reboot
reboot
