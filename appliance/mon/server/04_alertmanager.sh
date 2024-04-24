#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# install lts version of alert manager
VERSION="0.27.0"

# download
wget https://github.com/prometheus/alertmanager/releases/download/v${VERSION}/alertmanager-${VERSION}.linux-amd64.tar.gz

# extract contents and remove original archive
tar xvfz alertmanager-${VERSION}.linux-amd64.tar.gz && rm alertmanager-${VERSION}.linux-amd64.tar.gz

# create folders to install
mkdir /var/lib/alertmanager

# change into extracted folder
pushd alertmanager-${VERSION}.linux-amd64

# move to bin and etc
mv alertmanager amtool /usr/local/bin/
mv alertmanager.yml /etc/prometheus/alertmanager.yml
#mv consoles/ console_libraries/ /etc/prometheus/

# return to parent folder
popd

# and check prometheus is installed
alertmanager --version

# create systemctl service file
cat >/etc/systemd/system/alertmanager.service << EOL
[Unit]
Description=Alert Manager
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/alertmanager \
    --config.file /etc/prometheus/alertmanager.yml \
    --storage.path /var/lib/alertmanager/ \
    --log.level=info

[Install]
WantedBy=multi-user.target
EOL

# reload the systemd, enable the service and check its status
systemctl daemon-reload
systemctl enable alertmanager
systemctl restart alertmanager

# good then
systemctl status alertmanager
