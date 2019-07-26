#!/bin/csh

# build squid
cd /usr/ports/www/squid
make install clean

# autostart squid
grep -e '^\s*squid_enable\s*=\s*\"YES\"\s*$' /etc/rc.conf
if [ $? -ne 0 ]; then
    echo "squid_enable=\"YES\"" >> /etc/rc.conf
fi
