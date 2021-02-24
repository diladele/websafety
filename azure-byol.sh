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

# set new license
if [ -f license.pem ]; then
    sudo -u proxy cp license.pem /opt/websafety/etc/license.pem
fi

# tell 
echo "SUCCESS"
echo "SUCCESS"
echo "SUCCESS --- Azure BYOL instance is ready ---"
cat /opt/websafety/etc/license.pem | grep "Not After"
echo "SUCCESS"
echo "SUCCESS"
