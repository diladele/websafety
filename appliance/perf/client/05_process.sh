#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# version of squid exporter
VERSION="0.8.2"

# download
wget https://github.com/ncabatoff/process-exporter/releases/download/v${VERSION}/process-exporter-${VERSION}.linux-amd64.tar.gz

# extract contents and remove original archive
tar xvfz process-exporter-${VERSION}.linux-amd64.tar.gz && rm process-exporter-${VERSION}.linux-amd64.tar.gz

# change into extracted folder
pushd process-exporter-${VERSION}.linux-amd64

# make executable
chmod +x process-exporter

# move to bin
mv process-exporter /usr/local/bin/

# return to parent folder
popd

# check exporter is installed
process-exporter --version

# create yaml to export info about wsicapd
TODO

# create systemctl service file
cat >/etc/systemd/system/process_exporter.service << EOL
[Unit]
Description=Process Exporter for Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=proxy
Group=proxy
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/process-exporter -config.path /opt/websafety/etc/process_exporter.yml
StandardOutput=append:/opt/websafety/var/log/process_exporter.log
StandardError=append:/opt/websafety/var/log/process_exporter.log

[Install]
WantedBy=multi-user.target
EOL

# reload the systemd, enable the service and check its status
systemctl daemon-reload
systemctl enable process_exporter
systemctl restart process_exporter

# good then
systemctl status process_exporter


