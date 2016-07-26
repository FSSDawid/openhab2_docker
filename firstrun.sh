#!/bin/bash
if [ ! -d /config/userdata ]; then
	echo '******MOVING**********'
	mv /opt/openhab/conf /config/
	mv /opt/openhab/addons /config/
        mv /opt/openhab/userdata /config/

	echo '******LINKING**********'
	ln -s /config/conf /opt/openhab/conf
	ln -s /config/addons /opt/openhab/addons
        ln -s /config/userdata /opt/openhab/userdata

	chown -R openhab:openhab /config /config/addons /config/conf
	chmod -R 777 /config /config/addons /config/conf
fi

# Remove any lock files
# rm -f /var/lock/LCK.*
      
# /etc/init.d/openHAB-service start
