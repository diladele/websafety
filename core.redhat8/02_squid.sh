#!/bin/bash

# install RPMs as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# install stock squid with ecap libs - look for gotcha at https://github.com/diladele/websafety/issues/1300
dnf -y install squid libecap libecap-devel

# make squid autostart after reboot
systemctl enable squid
systemctl restart squid

# install Python 3
dnf -y install python3

# and distro module for it
pip3 install distro
