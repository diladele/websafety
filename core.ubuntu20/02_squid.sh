#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# add diladele apt key
wget -qO - https://packages.diladele.com/diladele_pub.asc | sudo apt-key add -

# add new repo
echo "deb https://squid57.diladele.com/ubuntu/ focal main" \
	> /etc/apt/sources.list.d/squid57.diladele.com.list

# and install
apt-get update && apt-get install -y \
	squid-common \
	squid-openssl \
	squidclient \
	libecap3 libecap3-dev

# change the number of default file descriptors
OVERRIDE_DIR=/etc/systemd/system/squid.service.d
OVERRIDE_CNF=$OVERRIDE_DIR/override.conf

mkdir -p $OVERRIDE_DIR

# generate the override file
rm $OVERRIDE_CNF
echo "[Service]"         >> $OVERRIDE_CNF
echo "LimitNOFILE=65535" >> $OVERRIDE_CNF

# and reload the systemd
systemctl daemon-reload
