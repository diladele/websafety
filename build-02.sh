#!/bin/bash

# check we are root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# install core modules of web safety
pushd core.ubuntu20
bash 02_squid.sh && \
bash 03_clamav.sh && \
bash 04_websafety.sh && \
bash 05_integrate.sh
popd

# install web safety ui
pushd ui.deb
bash 01_apache.sh && \
bash 02_webui.sh && \
bash 03_venv.sh && \
bash 04_integrate.sh
popd

# tell 
echo "SUCCESS"
echo "SUCCESS"
echo "SUCCESS Now run va.sh script for the appliance or azure-*.sh or aws-*.sh for cloud instances!"
echo "SUCCESS"
echo "SUCCESS"
