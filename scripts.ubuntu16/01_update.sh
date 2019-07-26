#!/bin/bash

# update should be done as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# remove unneeded packages
apt -y autoremove

# update and upgrade
apt update && apt -y upgrade

# the Azure deployment insists on this
sed -i 's/ClientAliveInterval 120/ClientAliveInterval 180/g' /etc/ssh/sshd_config

# and now reboot
reboot
