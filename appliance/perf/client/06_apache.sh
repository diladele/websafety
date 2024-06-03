#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# enable mod proxy
a2enmod proxy
a2enmod proxy_http

# copy the exporters.conf to apache sites available
cp -f exporters.conf /etc/apache2/sites-available/
cp -f exporters_port.conf /etc/apache2/conf-available/

# enable the site
a2ensite exporters
a2enconf exporters_port

# reload apache and check its status
systemctl restart apache2
systemctl status apache2

# good then dump the metrics
curl http://127.0.0.1:9090/metrics/node
curl http://127.0.0.1:9090/metrics/perf
curl http://127.0.0.1:9090/metrics/squid
curl http://127.0.0.1:9090/metrics/process

# ok then
echo "exporters configured successfully"
