#!/bin/bash
set -e

mkdir /etc/mywebapp
cp ../docker_conf/config.json /etc/mywebapp/

chown -R root:app /etc/mywebapp/
chmod 640 /etc/mywebapp/config.json
chmod 750 /etc/mywebapp

echo "CONFIG SCRIPT DONE"