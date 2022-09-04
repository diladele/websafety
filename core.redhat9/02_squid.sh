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

# install some useful packages
dnf -y install krb5-workstation mc net-tools python3 python3-pip

# and distro module for python
pip3 install distro
