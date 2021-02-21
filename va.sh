#!/bin/bash

# check we are root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# only in our va we change cloud config to preserve hostname, otherwise our UI cannot set it
sed -i 's/preserve_hostname: false/preserve_hostname: true/g' /etc/cloud/cloud.cfg

# install va
pushd appliance/va
bash 01_login.sh && bash 02_harden.sh
popd

# set new license
if [ -f license.pem ]; then
    sudo -u proxy cp license.pem /opt/websafety/etc/license.pem
fi

# tell 
echo "SUCCESS"
echo "SUCCESS"
echo "SUCCESS --- Virtual Appliance is ready, be sure to REBOOT ONCE BEFORE EXPORTING! --"
cat /opt/websafety/etc/license.pem | grep "Not After"
echo "SUCCESS"
echo "SUCCESS"
