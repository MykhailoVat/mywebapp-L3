#!/bin/bash
set -e

# Add Docker's official GPG key:
sudo apt update
sudo apt install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF


apt upgrade -y
apt install -y nginx nodejs npm postgresql docker.io
apt-get install -y docker-compose-plugin

systemctl enable docker
systemctl start docker

sudo -u postgres psql -c "CREATE DATABASE app;"
sudo -u postgres psql -c "CREATE USER myuser WITH PASSWORD 'pass';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE app TO myuser;"
sudo -u postgres psql -d app -c "GRANT ALL ON SCHEMA public TO myuser;"

cd /opt/mywebapp
#install as root, then give rights back to app
npm install
chown -R app:app "/opt/mywebapp"

echo "INSTALL SCRIPT DONE"

