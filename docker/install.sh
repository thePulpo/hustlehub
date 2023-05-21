#!/bin/bash

#--------------------------Pre Installation-------------------------------------

username=docker
password=docker
#adduser --disabled-password --gecos "" $username
#echo "$username:$password" | chpasswd

useradd -m -s /bin/bash -p "$(openssl passwd -1 "$password")" "$username"


#--------------------------Installation-----------------------------------------

# https://docs.docker.com/engine/install/ubuntu/

# Uninstall old versions
apt-get remove docker docker-engine docker.io containerd runc

# Set up the repository
## Update the apt package index and install packages to allow apt to use a repository over HTTPS:
apt-get update -y
apt-get install -y \
  ca-certificates \
  curl \
  gnupg

## Add Docker's official GPG key:
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --batch --yes --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

## Use the following command to set up the repository:
echo \
  "deb [arch=""$(dpkg --print-architecture)"" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  ""$(. /etc/os-release && echo "$VERSION_CODENAME")"" stable" |
  tee /etc/apt/sources.list.d/docker.list >/dev/null

# Install Docker Engine
## Update the apt package index:
apt-get update -y

## Install Docker Engine, containerd, and Docker Compose.
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
#docker run hello-world

#-----------------------------Post Installation---------------------------------

# https://docs.docker.com/engine/install/linux-postinstall/

# To create the docker group and add your user:
## Create the docker group.
groupadd docker

## Add your user to the docker group.
usermod -aG docker $username

## (Log out and log back in so that your group membership is re-evaluated.)
## You can also run the following command to activate the changes to groups:
#newgrp docker

## Verify that you can run docker commands without sudo.
#docker run hello-world

# Configure Docker to start on boot with systemd
systemctl enable docker.service
systemctl enable containerd.service

#-------------------------------------------------------------------------------

echo "Docker installation completed"
