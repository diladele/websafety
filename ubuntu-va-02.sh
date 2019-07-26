#!/bin/bash

# check we are root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# install web safety
pushd scripts.ubuntu18
bash 02_apache.sh && \
bash 03_squid.sh && \
bash 04_clamav.sh && \
bash 05_websafety.sh && \
bash 06_integrate.sh
popd

# install mysql
pushd scripts.mysql
bash 01_mysql.sh && bash 02_sync.sh
popd

# install va
pushd scripts.va
bash 01_login.sh && bash 02_harden.sh
popd

# tell 
echo "SUCCESS"
echo "SUCCESS"
echo "SUCCESS --- VA is Ready (check the license and publish it) ---"
cat /opt/websafety/etc/license.pem | grep "Not After"
echo "SUCCESS"
echo "SUCCESS"