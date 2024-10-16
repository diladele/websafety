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

# see if we have a new license to install
if [ -f license.pem ]; then
   cp license.pem /opt/websafety/etc/license.pem
   chown proxy:proxy /opt/websafety/etc/license.pem
fi

# change working dir into root
cd /root

# remove the build user completely
deluser --remove-home builder

# tell 
echo "SUCCESS"
echo "SUCCESS"
echo "SUCCESS --- Virtual Appliance is ready, do NOT REBOOT ANY MORE, just export as VA --"
cat /opt/websafety/etc/license.pem | grep "Not After"
echo "SUCCESS"
echo "SUCCESS"

# and shutdown after 1 minute
cd /root && shutdown -P +1
