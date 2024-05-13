#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# install lts version of prometheus
VERSION="2.45.4"

# download
wget https://github.com/prometheus/prometheus/releases/download/v${VERSION}/prometheus-${VERSION}.linux-amd64.tar.gz

# extract contents and remove original archive
tar xvfz prometheus-${VERSION}.linux-amd64.tar.gz && rm prometheus-${VERSION}.linux-amd64.tar.gz

# create folders to install
mkdir /etc/prometheus /var/lib/prometheus

# change into extracted folder
pushd prometheus-${VERSION}.linux-amd64

# move to bin and etc
mv prometheus promtool /usr/local/bin/
mv prometheus.yml /etc/prometheus/prometheus.yml
mv consoles/ console_libraries/ /etc/prometheus/

# return to parent folder
popd

# and check prometheus is installed
prometheus --version

# now we will configure prometheus to run as a system daemon, add a dedicated user
useradd -rs /bin/false prometheus

# and make it owner
chown -R prometheus: /etc/prometheus /var/lib/prometheus

# create systemctl service file
cat >/etc/systemd/system/prometheus.service << EOL
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries \
    --web.listen-address=0.0.0.0:9090 \
    --web.enable-lifecycle \
    --log.level=info

[Install]
WantedBy=multi-user.target
EOL

# reload the systemd, enable the service and check its status
systemctl daemon-reload
systemctl enable prometheus
systemctl restart prometheus

# good then
systemctl status prometheus

