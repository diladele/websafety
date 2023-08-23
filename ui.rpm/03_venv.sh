#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# install python 3 development libs
dnf -y install python3-devel redhat-rpm-config python3-pyOpenSSL python3-requests

# rust is required for PyOpenSSL
# dnf -y module install rust-toolset

# create a virtual environment in the /opt/websafety-ui folder
python3 -m venv /opt/websafety-ui/env

# install required packages into virtual environment
/opt/websafety-ui/env/bin/pip3 install -r /opt/websafety-ui/var/console/requirements.txt

# sync ui and actual files in disk (note UI does not manage network by default)
sudo -u squid /opt/websafety-ui/env/bin/python3 /opt/websafety-ui/var/console/generate.py --core
sudo -u websafety /opt/websafety-ui/env/bin/python3 /opt/websafety-ui/var/console/generate.py --ui

# relabel folder just in case
chown -R websafety:websafety /opt/websafety-ui
