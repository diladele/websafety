#!/bin/bash

# check we are root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# install core modules of web safety
pushd core.ubuntu18
bash 02_squid.sh && \
bash 03_clamav.sh && \
bash 04_websafety.sh && \
bash 05_integrate.sh
popd

# install web safety ui
pushd ui.deb
bash 01_apache.sh && bash 02_webui.sh
popd

# install va
pushd appliance
bash 01_login.sh && bash 02_harden.sh
popd

# tell 
echo "SUCCESS"
echo "SUCCESS"
echo "SUCCESS --- VA is Ready (check the license and publish it) ---"
cat /opt/websafety/etc/license.pem | grep "Not After"
echo "SUCCESS"
echo "SUCCESS"
