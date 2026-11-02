#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# get diladele apt key, dearmor it and add to trusted storage
curl https://www.diladele.com/pkg/diladele_pub.asc | gpg --dearmor >/etc/apt/trusted.gpg.d/diladele_pub.asc.gpg

# add new repo
echo "deb https://diladele.github.io/repo-squid-7_7_1-ubuntu-26_04/repo/ubuntu/ resolute main" \
   >/etc/apt/sources.list.d/squid-7_7_1.diladele.github.io.list

# pin it so that unexpected updates from Ubuntu team leave the tested squid in place
cat >/etc/apt/preferences.d/squid << EOL
Package: squid squid-common squid-openssl
Pin: origin "diladele.github.io"
Pin-Priority: 990

Package: squid squid-common squid-openssl
Pin: release o=Ubuntu
Pin-Priority: -1
EOL

# update the apt and show the cache policy to check for
apt update && apt-cache policy squid

# and finally install
apt update && apt install -y squid-openssl

# create the override folder for squid
mkdir -p /etc/systemd/system/squid.service.d/

# and override the default number of file descriptors
cat >/etc/systemd/system/squid.service.d/override.conf << EOL
[Service]
LimitNOFILE=65535
EOL

# finally reload the systemd
systemctl daemon-reload