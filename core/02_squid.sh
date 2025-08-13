#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# get the diladele apt key into local file
wget https://packages.diladele.com/diladele_pub.asc

# cat it and dearmor
cat diladele_pub.asc | gpg --dearmor -o diladele_pub.asc.gpg

# and add it to the trusted storage
mv diladele_pub.asc.gpg /etc/apt/trusted.gpg.d/

# add new repo
echo "deb https://squid71.diladele.com/ubuntu/ noble main" \
   > /etc/apt/sources.list.d/squid71.diladele.com.list

# and install
apt update && apt install -y \
   squid-common \
   squid-openssl \
   libecap3 libecap3-dev

# change the number of default file descriptors
OVERRIDE_DIR=/etc/systemd/system/squid.service.d
OVERRIDE_CNF=$OVERRIDE_DIR/override.conf

mkdir -p $OVERRIDE_DIR

# generate the override file
rm $OVERRIDE_CNF
echo "[Service]"         >> $OVERRIDE_CNF
echo "LimitNOFILE=65535" >> $OVERRIDE_CNF

# switch to openssl based squid
update-alternatives --set squid /usr/sbin/squid-openssl

# reload the systemd
systemctl daemon-reload
