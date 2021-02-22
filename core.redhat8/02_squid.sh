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

# we need distro module in Python < 3.8 (ubuntu20)
pip3 install distro
