#!/bin/bash

# we must be root to install packages
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# install the server
if [ -f /etc/centos-release ] || [ -f /etc/redhat-release ]; then
	
	# centos, redhat
	yum install -y mariadb-server mariadb patch MySQL-python

	# stop mysql
	systemctl stop mariadb.service

	# copy the optimized mysql settings
	yes | cp -f websafety.cnf /etc/my.cnf.d/websafety.cnf

	# enable and start it
	systemctl enable mariadb.service
	systemctl start mariadb.service

else

	# debian, ubuntu
	export DEBIAN_FRONTEND=noninteractive 

	# install it
	apt-get -y install mysql-server python3-mysqldb

	# stop mysql
	service mysql stop

	# copy the optimized mysql settings
	yes | cp -f websafety.cnf /etc/mysql/conf.d/websafety.cnf

	# remove log files
	rm -f /var/lib/mysql/ib_logfile0
	rm -f /var/lib/mysql/ib_logfile1

	# and start again (mysql will recreate the log files this will take some time)
	service mysql start

	# now to get nice looking and clean error log
	service mysql stop && rm -f /var/log/mysql/error.log && service mysql start
fi
