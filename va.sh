#!/bin/bash

# check we are root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# install va scripts
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
echo "SUCCESS --- Virtual Appliance is ready, do NOT REBOOT ANY MORE, just export as VA --"
cat /opt/websafety/etc/license.pem | grep "Not After"
echo "SUCCESS"
echo "SUCCESS"
