#!/bin/bash

# firewall setup should be done as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# check kernel forwarding is enabled
enabled=`cat /proc/sys/net/ipv4/ip_forward`
if [[ $enabled -ne 1 ]]; then
    echo "Kernel forwarding seems to be disabled, are internal and external zones assigned correctly?" 1>&2
   	exit 1
fi

# we will have the following ports open on our gateway for all internal clients
#   22   - sshd for SSH
#   80   - http for HTTP traffic
#   443  - https for HTTPS traffic
#   8000 - for Web Safety UI
#   3126 - for intercepted HTTP traffic for Squid
#   3127 - for intercepted HTTPS traffic for Squid
#   3128 - for normal explicit proxy traffic
#
firewall-cmd --zone=internal --add-service=ssh --permanent
firewall-cmd --zone=internal --add-service=http --permanent
firewall-cmd --zone=internal --add-service=https --permanent
firewall-cmd --zone=internal --add-port=8000/tcp --permanent
firewall-cmd --zone=internal --add-port=3126/tcp --permanent
firewall-cmd --zone=internal --add-port=3127/tcp --permanent
firewall-cmd --zone=internal --add-port=3128/tcp --permanent

# and copy the direct xml
cp direct.xml /etc/firewalld/direct.xml
