#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# get diladele apt key, dearmor it and add to trusted storage
curl https://packages.diladele.com/diladele_pub.asc | gpg --dearmor >/etc/apt/trusted.gpg.d/diladele_pub.asc.gpg

# add new repo
echo "deb https://diladele.github.io/repo-squid-7_4_1-ubuntu-24_04/repo/ubuntu/ noble main" \
   >/etc/apt/sources.list.d/squid-7_4_1.diladele.github.io.list

# and install
apt update && apt install -y \
   squid-common \
   squid-openssl \
   libecap3 libecap3-dev

# create the override folder for squid
mkdir -p /etc/systemd/system/squid.service.d/

# and override the default number of file descriptors
cat >/etc/systemd/system/squid.service.d/override.conf << EOL
[Service]
LimitNOFILE=65535
EOL

# switch to openssl based squid
update-alternatives --set squid /usr/sbin/squid-openssl

# finally reload the systemd
systemctl daemon-reload
