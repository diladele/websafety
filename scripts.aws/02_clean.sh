#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

#
# NOTE: to fix "A default password was found for the following user(s): /etc/mysql/debian.cnf" we used
# https://support.n2ws.com/portal/kb/articles/a-clarification-about-the-debian-sys-maint-vulnerability-reported-by-aws-marketplace
#

# fix the mysql default user password error
# OLD_MYSQL_PASS=`cat /etc/mysql/debian.cnf | grep password | sort | uniq | awk '{ print $3 }'`
# mysql -u debian-sys-maint -p"$OLD_MYSQL_PASS" < setpass.sql

# replace the password
# sed -i "s/$OLD_MYSQL_PASS/vtrCUtsRcAW9W8Da/g" /etc/mysql/debian.cnf

# remove the debian conf - not sure if it is ok to do that?
rm /etc/mysql/debian.cnf

# remove all keys
shred -u /etc/ssh/*_key /etc/ssh/*_key.pub

# authorized keys
find / -name "authorized_keys" -exec rm –f {} \;

# remove source control
find /root/ /home/*/ -name .cvspass -exec rm –f {} \;
find /root/.subversion/auth/svn.simple/ /home/*/.subversion/auth/svn.simple/ -exec rm –rf {} \;

# remove all scripts
cd /home/ubuntu
rm -Rf scripts.ubuntu18
rm -Rf scripts.mysql
rm -Rf scripts.aws

# remove history
find /root/.*history /home/*/.*history -exec rm -f {} \;
