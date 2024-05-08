#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# version of squid exporter
VERSION="1.11.0"

# download
wget https://github.com/boynux/squid-exporter/releases/download/v${VERSION}/squid-exporter-linux-amd64

# rename
mv squid-exporter-linux-amd64 squid-exporter && chmod +x squid-exporter

# move to bin
mv squid-exporter /usr/local/bin/

# and check exporter is installed
squid-exporter --version

# create systemctl service file
cat >/etc/systemd/system/squid_exporter.service << EOL
[Unit]
Description=Squid Exporter for Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=proxy
Group=proxy
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/squid-exporter -squid-hostname "localhost" -squid-port 3128
StandardOutput=append:/opt/websafety/var/log/squid_exporter.log
StandardError=append:/opt/websafety/var/log/squid_exporter.log

[Install]
WantedBy=multi-user.target
EOL

# reload the systemd, enable the service and check its status
systemctl daemon-reload
systemctl enable squid_exporter
systemctl restart squid_exporter

# good then
systemctl status squid_exporter


