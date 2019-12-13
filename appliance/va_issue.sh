#!/bin/bash

CPUNUM=`cat /proc/cpuinfo | grep processor | wc -l`
RAMNFO=`free -mh | grep Mem: | awk {'print $2, "total,", $4, "free" '}`
DISKSZ=`df -h | grep "/$" | awk {'print $2, "total,", $4, "free" '}`
VA_VER=`/opt/websafety/bin/ldap --version`
SQUID_VER=`/usr/sbin/squid -v | grep "Version " | awk {'print $4'}`

# some string manupulation magic
OSINFO_TMP1=`cat /etc/os-release | grep ^VERSION=`
OSINFO_NAME=${OSINFO_TMP1#VERSION=}
OSINFO_NAME=${OSINFO_NAME#\"}
OSINFO_NAME=${OSINFO_NAME%\"}

OSINFO_TMP2=`cat /etc/os-release | grep ^NAME=`
OSINFO_DIST=${OSINFO_TMP2#NAME=}
OSINFO_DIST=${OSINFO_DIST#\"}
OSINFO_DIST=${OSINFO_DIST%\"}

echo "Welcome to Web Safety ICAP web filter for Squid!"
echo 
echo "Operating System    $OSINFO_DIST, $OSINFO_NAME"
echo "System Kernel       \\r"
echo "System Arch         \\m"
echo "RAM Available       $RAMNFO"
echo "CPU Count           $CPUNUM"
echo "Hard Disk Size      $DISKSZ"
echo
echo "Appliance Version   $VA_VER"
echo "Squid Version       $SQUID_VER"
echo "Default Username    root"
echo "Default Password    Passw0rd"
echo "Installation Dir    /opt/websafety"
echo 
if [ -f /etc/centos-release ] || [ -f /etc/redhat-release ]
then
    echo "To use this Virtual Appliance - adjust your browser proxy settings to point"
    echo "to the IP address or domain name of this box (port 3128) and browse the web."
    echo 
    echo "Full featured Administrators Web Console is available at this box port 80"
else
    echo "To use this Virtual Appliance - adjust your browser proxy settings to point"
    echo "to the IP address or domain name of this box \\4, port 3128 and browse the web."
    echo 
    echo "Full featured Administrators Web Console is available at http://\\4:80"
fi
echo 
echo    