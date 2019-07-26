#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# copy the change password script to bin folder
cp chpass_aws.sh /opt/websafety/bin/

# make it executable
chmod +x /opt/websafety/bin/chpass_aws.sh

#  create systemd service that runs exactly once
cp chpass_aws.service /etc/systemd/system/chpass_aws.service

# enable it
systemctl enable chpass_aws.service
systemctl daemon-reload