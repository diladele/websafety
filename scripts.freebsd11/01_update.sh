#!/bin/csh

# update the system
freebsd-update fetch
freebsd-update install

# bootstrap pkg
env ASSUME_ALWAYS_YES=YES pkg bootstrap

# get new ports
portsnap fetch
portsnap extract

# and reboot
reboot
