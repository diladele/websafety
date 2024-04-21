#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# install lts version of prometheus
VERSION="1.7.0"

# download
wget https://github.com/prometheus/node_exporter/releases/download/v${VERSION}/node_exporter-${VERSION}.linux-amd64.tar.gz

# extract contents and remove original archive
tar xvfz node_exporter-${VERSION}.linux-amd64.tar.gz && rm node_exporter-${VERSION}.linux-amd64.tar.gz

# change into extracted folder
pushd node_exporter-${VERSION}.linux-amd64

# move to bin and etc
mv node_exporter /usr/local/bin

# return to parent folder
popd

# and check exporter is installed
node_exporter --version

# now we will configure exporter to run as a system daemon, add a dedicated user
useradd -rs /bin/false node_exporter

# create systemctl service file
cat >/etc/systemd/system/node_exporter.service << EOL
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOL

# reload the systemd, enable the service and check its status
systemctl daemon-reload
systemctl enable node_exporter
systemctl restart node_exporter

# good then
systemctl status node_exporter

