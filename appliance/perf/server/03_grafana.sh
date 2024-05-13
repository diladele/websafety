#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

apt install -y apt-transport-https software-properties-common

# import grafana gpg key
wget -q -O /usr/share/keyrings/grafana.key https://apt.grafana.com/gpg.key

# add stable grafana repo
echo "deb [signed-by=/usr/share/keyrings/grafana.key] https://apt.grafana.com stable main" | tee -a /etc/apt/sources.list.d/grafana.list

# update the packages info
apt update

# install grafana
apt install -y grafana

# reload the systemd, enable and start grafana
systemctl daemon-reload
systemctl enable grafana-server.service
systemctl start grafana-server

# good then
systemctl status grafana-server
