#!/bin/bash
#
# update root password in the Web Safety to a random value
# required for vm publication in the AWS Cloud Marketplace
#

FLAG_FILE="/opt/websafety/var/console/password_reset.flag"

if [ -f $FLAG_FILE ]; then

    echo "Flag file $FLAG_FILE exists, thus root password was changed from the default"
    echo "Password value at least once, no need to do anything, skipping..."
    
else

    # generate new password 12 characters long
    NEWPASW=$(openssl rand -base64 12 | sed -e 's/\//-/g')

    # update the password in the database 
    python3 /opt/websafety/var/console/reset_password.py --password=$NEWPASW

    # change the template too so that user sees the new password right away
    sed -i "s/Passw0rd/${NEWPASW}/g" /opt/websafety/var/console/frame/templates/login.html

    # mark the updated password so that we do not regenerate it next reboot
    echo "Do NOT remove this file!" >  "$FLAG_FILE"
    echo "Do NOT remove this file!" >> "$FLAG_FILE"
    echo "Do NOT remove this file!" >> "$FLAG_FILE"
    echo "" >> "$FLAG_FILE"
    echo "" >> "$FLAG_FILE"

    echo "If you remove this flag file, the /etc/systemd/service/chpass_aws.service service " >> "$FLAG_FILE"
    echo "will automatically call /opt/websafety/bin/chpass_aws.sh file that will forcefully" >> "$FLAG_FILE"
    echo "generate a new random file for root user in Web Safety UI. This is required for   " >> "$FLAG_FILE"
    echo "VMs generated from template in Amazon AWS."                                         >> "$FLAG_FILE"
    echo "" >> "$FLAG_FILE"
    echo "" >> "$FLAG_FILE"


    echo "Note the password for system root user in console will not be changed!"             >> "$FLAG_FILE"
    echo "You can always login to this box through SSH and reset the root password for"       >> "$FLAG_FILE"
    echo "Web Safety UI using /opt/websafety/var/console/reset_password.py command."          >> "$FLAG_FILE"
    
fi
