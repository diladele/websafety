#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# remove all keys
shred -u /etc/ssh/*_key /etc/ssh/*_key.pub

# authorized keys
find / -name "authorized_keys" -exec rm –f {} \;

# remove source control
find /root/ /home/*/ -name .cvspass -exec rm –f {} \;
find /root/.subversion/auth/svn.simple/ /home/*/.subversion/auth/svn.simple/ -exec rm –rf {} \;

# remove all scripts
cd /home/ubuntu
rm -Rf core.ubuntu18
rm -Rf ui.deb
rm -Rf appliance

rm build-01.sh
rm build-02.sh
rm aws-byol.sh

# remove history
find /root/.*history /home/*/.*history -exec rm -f {} \;
