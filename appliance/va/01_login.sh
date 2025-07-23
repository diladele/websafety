#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# our va is in amsterdam timezone
timedatectl set-timezone "Europe/Amsterdam" 

# change cloud config to preserve hostname, otherwise our UI cannot set it
sed -i 's/preserve_hostname: false/preserve_hostname: true/g' /etc/cloud/cloud.cfg

# we do not allow root login for ssh any more in virtual appliance (use terminal console)
# sed -i "s/#\{0,1\}PermitRootLogin *.*$/PermitRootLogin yes/g" /etc/ssh/sshd_config

# install vm tools (only if vmware is detected)
dmidecode -s system-product-name | grep -i "vmware" > /dev/null
if [ $? -eq 0 ]; then
    
        echo "Detected VMware, installing open-vm-tools..."
        apt update > /dev/null
        apt install -y open-vm-tools


        # reset the machine-id to force different dhcp addreses - https://kb.vmware.com/s/article/82229
        echo -n > /etc/machine-id
        rm /var/lib/dbus/machine-id
        ln -s /etc/machine-id /var/lib/dbus/machine-id
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

# in Ubuntu 24.04 the installer creates 50-cloud-init.yaml but our Admin UI expects
# the 00-installer-config.yaml, so here we just rename it for simplicity
if [ -e "/etc/netplan/50-cloud-init.yaml" ]; then
   mv /etc/netplan/50-cloud-init.yaml /etc/netplan/00-installer-config.yaml
fi

# and make it readable by the Admin UI
chmod a+r /etc/netplan/00-installer-config.yaml

# switch Admin UI to actually manage the network
sudo -u websafety /opt/websafety-ui/env/bin/python3 /opt/websafety-ui/var/console/utils.py --network=ubuntu24

# and sync ui data and actual files in disk
sudo -u proxy /opt/websafety-ui/env/bin/python3 /opt/websafety-ui/var/console/generate.py --core
sudo -u websafety /opt/websafety-ui/env/bin/python3 /opt/websafety-ui/var/console/generate.py --ui

#
echo "Success, run next step please."
