#!/bin/bash

DIR="/var/www/html"

# Check if /var/www/html empty or not
if [ "$(ls -A $DIR)" ]; then
     echo "Enjoy your IPPlan ...!"
else
    echo "Copy IPPlan source to webroot ...!"
    cp -r /usr/src/ipplan/* $DIR
    chmod -R 750 $DIR
    chown -R root.apache $DIR
fi

# Set IPPlan configuration
chk_conf=`sed -n '34p' $DIR/config.php | awk '{print $2}'`
if [ "$chk_conf" == "'localhost');" ]; then
        echo "Configuration has been changed...!"
        cd $DIR
        sed -i "34s/'localhost'/'$DB_IPPLAN_HOST'/" config.php
        sed -i "35s/'ipplan'/'$DB_IPPLAN_USER'/" config.php
        sed -i "36s/'ipplan'/'$DB_IPPLAN_NAME'/" config.php
        sed -i "37s/'ipplan99'/'$DB_IPPLAN_PASSWORD'/" config.php
fi

# Make sure we're not confused by old, incompletely-shutdown httpd
# context after restarting the container.  httpd won't start correctly
# if it thinks it is already running.
rm -rf /run/httpd/* /tmp/httpd*

exec /usr/sbin/apachectl -DFOREGROUND
