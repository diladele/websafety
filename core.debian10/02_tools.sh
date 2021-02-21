#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# install build tools
apt-get -y install \
    devscripts build-essential fakeroot sudo \
    debhelper dh-autoreconf dh-apparmor cdbs ed net-tools

# install additional header packages for squid 4
apt-get -y install \
    libcppunit-dev \
    libsasl2-dev \
    libxml2-dev \
    libkrb5-dev \
    libdb-dev \
    libnetfilter-conntrack-dev \
    libexpat1-dev \
    libcap2-dev \
    libldap2-dev \
    libpam0g-dev \
    libgnutls28-dev \
    libssl-dev \
    libdbi-perl \
    libecap3 \
    libecap3-dev \
    libsystemd-dev

# install build dependences for squid
apt-get -y build-dep squid

# we need distro module in python 3.7, so get pip
apt install -y python3-pip

# and install it
pip3 install distro
