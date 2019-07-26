#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# remove non needed packages
apt -y autoremove

# reset system root password to match documented one
sudo echo root:Passw0rd | sudo chpasswd

# disable the user we used to build the virtual appliance
passwd user -l

# exit successfully
echo "VA generated successfully, please reboot"
