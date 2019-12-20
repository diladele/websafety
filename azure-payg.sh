#!/bin/bash

# check we are root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

#
# be sure to first run
#
# 	bash build_01.sh
# 	bash build_02.sh
#

#  create azure license update service that runs exactly once
cp appliance/azure/wslicd.service /etc/systemd/system/wslicd.service

# enable it
systemctl enable wslicd.service
systemctl daemon-reload

# set new cloud license
if [ -f license-cloud.pem ]; then
    sudo -u proxy cp license-cloud.pem /opt/websafety/etc/license.pem
fi

# tell 
echo "SUCCESS"
echo "SUCCESS"
echo "SUCCESS --- Azure PAYG instance is ready ---"
cat /opt/websafety/etc/license.pem | grep "Not After"
echo "SUCCESS"
echo "SUCCESS"
