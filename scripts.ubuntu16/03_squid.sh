#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# add diladele apt key
wget -qO - http://packages.diladele.com/diladele_pub.asc | sudo apt-key add -

# add new repo
echo "deb http://squid3527.diladele.com/ubuntu/ xenial main" > /etc/apt/sources.list.d/squid3527.diladele.com.list

# and install
apt update && apt install -y \
	libecap3 \
	libecap3-dev \
	squid-common \
	squid \
	squidclient \
	mc
