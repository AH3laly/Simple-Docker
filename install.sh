#!/bin/bash
# Software Development and Deployment Script
#Created By github/AH3laly

rm -rf /opt/simple-docker/
cp -r src /opt/simple-docker
chown root:root /opt/simple-docker -R
chmod 700  /opt/simple-docker -R
ln -s /opt/simple-docker/simple-docker.sh /bin/simple-docker
ln -s /opt/simple-docker/simple-docker.sh /bin/sdocker
/bin/sdocker initialize
