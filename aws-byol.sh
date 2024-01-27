#!/bin/bash

# check we are root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# install aws
pushd appliance/aws
bash 01_pasw.sh && bash 02_clean.sh 
popd

# set new license
if [ -f license.pem ]; then
   cp license.pem /opt/websafety/etc/license.pem
   chown proxy:proxy /opt/websafety/etc/license.pem
fi

# tell 
echo "SUCCESS"
echo "SUCCESS"
echo "SUCCESS --- AWS AMI is ready ---"
cat /opt/websafety/etc/license.pem | grep "Not After"
echo "SUCCESS"
echo "SUCCESS"
