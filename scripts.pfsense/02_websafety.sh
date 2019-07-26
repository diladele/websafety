#!/bin/sh

# see if websafety group exists
echo "Searching for group websafety..."
getent group websafety >/dev/null

if [ $? -ne 0 ]; then
    echo "Group websafety is not found, please add it through pfSense Web UI."
    exit 1
else
    echo "Group websafety already exists, continuing..."
fi

# see if websafety user exists
echo "Searching for user websafety..."
getent passwd websafety >/dev/null

if [ $? -ne 0 ]; then
    echo "User websafety is not found, please add it through pfSense Web UI."
    exit 2
else
    echo "User websafety already exists, continuing..."
fi

# how to check user websafety is in websafety group???

# setup some configuration variables
ARCH=`uname -m`
DDWS_VERSION=7.0.0
DDWS_BUILD=7A5E

# get latest version of web safety
fetch http://packages.diladele.com/websafety/$DDWS_VERSION.$DDWS_BUILD/$ARCH/release/freebsd11/websafety-$DDWS_VERSION-$ARCH.txz

# and install it
pkg install -y websafety-$DDWS_VERSION-$ARCH.txz
