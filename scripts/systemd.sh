#!/bin/bash
set -e

mkdir /etc/systemd/system/mywebapp
#cp mywebapp.service /etc/systemd/system/
#cp mywebapp.socket /etc/systemd/system/
cp docker_conf/mywebapp.service /etc/systemd/system/

systemctl daemon-reload
#systemctl start mywebapp.socket
#systemctl enable mywebapp.socket
systemctl start mywebapp.service
systemctl enable mywebapp.service

echo "SYSTEMD SCRIPT DONE"