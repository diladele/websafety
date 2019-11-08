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

# the Azure deployment insists on this
sed -i 's/ClientAliveInterval 120/ClientAliveInterval 180/g' /etc/ssh/sshd_config

# change cloud config to preserve hostname, otherwise our UI cannot set it
sed -i 's/preserve_hostname: false/preserve_hostname: true/g' /etc/cloud/cloud.cfg

# and now reboot
reboot
