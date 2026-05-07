#!/bin/bash
set -e

if [ "$EUID" -ne 0 ]; then
  echo "❌ ! RUN THIS SCRIPT WITH SUDO !"
  exit 1
fi

#docker
# Add Docker's official GPG key:
apt update
apt install -y ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

apt install -y docker.io

systemctl enable docker
systemctl start docker

usermod -aG docker "$USER"
newgrp docker

# py tools
apt install -y python3 python3-pip

HOME_DIR=$(eval echo "~$SUDO_USER")
# Create a folder
sudo -u "$SUDO_USER" mkdir "$HOME_DIR"/actions-runner && cd "$HOME_DIR"/actions-runner
# Download the latest runner package
sudo -u "$SUDO_USER" curl -o actions-runner-linux-x64-2.334.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.334.0/actions-runner-linux-x64-2.334.0.tar.gz
# Extract the installer
sudo -u "$SUDO_USER" tar xzf ./actions-runner-linux-x64-2.334.0.tar.gz

echo "RUNNER-VM PREPARED, NEXT STEP: CONFIGURE RUNNER (MANUALLY)"