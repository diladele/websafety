#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# for now just copy the compiled version to predefined location on this machine
# in future the smon will be part of websafety build

# move to bin and etc
mv /home/builder/diladele/webfilter-core/bin/amd64/release/smond /opt/websafety/bin

# return to parent folder
# popd

# and check exporter is installed
# node_exporter --version

# now we will configure exporter to run as a system daemon, add a dedicated user
# useradd -rs /bin/false node_exporter

# create systemctl service file
cat >/etc/systemd/system/smond.service << EOL
[Unit]
Description=WebSafety Exporter for Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=proxy
Group=proxy
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/opt/websafety/bin/smond
StandardOutput=append:/opt/websafety/var/log/smond.log
StandardError=append:/opt/websafety/var/log/smond.log

[Install]
WantedBy=multi-user.target
EOL

# reload the systemd, enable the service and check its status
systemctl daemon-reload
systemctl enable smond
systemctl restart smond

# good then
systemctl status smond

