#!/bin/bash
# base configuration nicked from github.com/limetech/dockerapp-plex
# Configure user nobody to match unRAID's settings
usermod -u 99 nobody
usermod -g 100 nobody
usermod -d /home nobody
chown -R nobody:users /home

# chfn workaround - Known issue within Dockers
ln -s -f /bin/true /usr/bin/chfn

# Update Apt-Get
add-apt-repository ppa:openjdk-r/ppa -y
apt-get -q update

# Set Timezone
apt-get install -y ntp
echo 'server 0.uk.pool.ntp.org' > /etc/ntp.conf
echo 'Europe/Warsaw' > /etc/timezone

# Install Java 8
apt-get purge -qy openjdk*
apt-get install -y openjdk-8-jdk

# Downloads Openhab and extras
apt-get install -qy wget unzip
mkdir /downloads
cd /downloads

# force docker hub update 1

# RUNTIME
wget -nv https://openhab.ci.cloudbees.com/job/openHAB-Distribution/lastSuccessfulBuild/artifact/distributions/openhab-online/target/openhab-online-2.0.0-SNAPSHOT.zip
unzip -q openhab-online-2.0.0-SNAPSHOT.zip -d /opt/openhab

# HABMIN
wget -nv https://github.com/cdjackson/HABmin2/releases/download/0.1.6/org.openhab.ui.habmin_0.1.6.jar
cp -rp org.openhab.ui.habmin_0.1.6.jar /opt/openhab/addons/org.openhab.ui.habmin_0.1.6.jar

# Add user:group and chown
adduser --system --no-create-home --group openhab
usermod openhab -a -G dialout
chown -R openhab:openhab /opt/openhab
chmod +x /opt/openhab/addons/*.jar

# Add startup
mkdir -p /etc/service/openhab
cat <<'EOT' > /etc/service/openhab/run
!/bin/bash
umask 000
exec /etc/init.d/openhab start
EOT
chmod +x /etc/service/openhab/run
ln -s /opt/openhab/runtime/karaf/bin/start /etc/init.d/openhab

# Quick Cleanup
rm /opt/openhab/*.bat 
rm -r /downloads
rm /install.sh
