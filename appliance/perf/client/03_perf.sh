#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# for now just enable the perf service which comes with web safety
systemctl enable wsperfd
systemctl restart wsperfd

# good then
systemctl status wsperfd
