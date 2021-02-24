#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# change cloud config to preserve hostname, otherwise our UI cannot set it
sed -i 's/preserve_hostname: false/preserve_hostname: true/g' /etc/cloud/cloud.cfg

# allow root login for ssh
sed -i "s/#\{0,1\}PermitRootLogin *.*$/PermitRootLogin yes/g" /etc/ssh/sshd_config

# install vm tools (only if vmware is detected)
dmidecode -s system-product-name | grep -i "vmware" > /dev/null
if [ $? -eq 0 ]; then
    echo "Detected VMware, installing open-vm-tools..."
    apt update > /dev/null
    apt install -y open-vm-tools
fi

# copy the handy monitor.sh script to installation folder
cp monitor.sh /opt/websafety/bin/

# and make it executable
chmod +x /opt/websafety/bin/monitor.sh

# copy the /etc/issue creation script to installation folder
cp va_issue.sh /opt/websafety/bin/

# make script executable
chmod +x /opt/websafety/bin/va_issue.sh

#  create systemd service that runs everytime network is restarted to update the /etc/issue login banner
cp wsissue.service /etc/systemd/system/wsissue.service

# enable it
systemctl enable wsissue.service

# finally let ui to manage the network
sudo -u websafety python3 /opt/websafety-ui/var/console/utils.py --network=ubuntu20

# and sync ui data and actual files in disk
sudo -u proxy python3 /opt/websafety-ui/var/console/generate.py --core
sudo -u websafety python3 /opt/websafety-ui/var/console/generate.py --ui

#
echo "Success, run next step please."
