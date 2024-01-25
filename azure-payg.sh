#!/bin/bash

# check we are root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# we need this to pass the Azure Certification Tool tests
sed -i 's/#ClientAliveInterval 0/ClientAliveInterval 180/g' /etc/ssh/sshd_config

# disable network management from Admin UI on Azure
patch /opt/websafety-ui/var/console/node/models.py < appliance/azure/models.py.patch

#  create azure license update service that runs exactly once
cp appliance/azure/wslicd.service /etc/systemd/system/wslicd.service

# enable it
systemctl enable wslicd.service
systemctl daemon-reload

# set new cloud license
if [ -f /home/builder/license-cloud.pem ]; then
   cp /home/builder/license-cloud.pem /opt/websafety/etc/license.pem
   chown proxy:proxy /opt/websafety/etc/license.pem
fi

# tell 
echo "SUCCESS"
echo "SUCCESS"
echo "SUCCESS --- Azure PAYG instance is ready ---"
cat /opt/websafety/etc/license.pem | grep "Not After"
echo "SUCCESS"
echo "SUCCESS"
