#!/bin/bash

lxc_install_docker() {
  # The name of the new Container
  # The ID of the new Container
  local ID="$1"
  # The DIR of the installation files
  local DIR="$2"
  # Set the docker user name
  #USERNAME="docker"
  #PASSWORD="docker"

  # pre docker install
  #pct exec $ID -- bash -c "useradd -m -s /bin/bash -p \$(openssl PASSWORD -1 $PASSWORD) $USERNAME"

  # Loop through all files in the DIR
  for FILE in "$DIR"/*; do
    # Get the filename without the path
    FILENAME=$(basename "$FILE")

    # Push the file to the container
    pct push $ID "$FILE" "/tmp/$FILENAME"
  done
  # Execute the installation files on the container
  pct exec $ID -- su -c "/bin/bash /tmp/install.sh" root &
  wait

  # Deploy Portainer Agent
  pct exec $ID -- su -c "docker run -d \
    -p 9001:9001 \
    --name portainer_agent \
    --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /var/lib/docker/volumes:/var/lib/docker/volumes \
    portainer/agent:2.17.1" docker
}

# Call the function with your desired arguments
lxc_install_docker "106" "./docker"

install_docker() {
  # Get the username and password parameters
  local USERNAME=$1
  local PASSWORD=$2

  # pre install
  adduser --disabled-password --gecos "" $USERNAME
  echo "$USERNAME:$PASSWORD" | chpasswd

  # https://docs.docker.com/engine/install/ubuntu/
  ##### Installation #####

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

  # https://docs.docker.com/engine/install/linux-postinstall/
  ##### Post-Installation #####
  # To create the docker group and add your user:
  ## Create the docker group.
  groupadd docker

  ## Add your user to the docker group.
  usermod -aG docker $USERNAME

  ## (Log out and log back in so that your group membership is re-evaluated.)
  ## You can also run the following command to activate the changes to groups:
  #newgrp docker

  ## Verify that you can run docker commands without sudo.
  docker run hello-world

  # Configure Docker to start on boot with systemd
  systemctl enable docker.service
  systemctl enable containerd.service
  echo "completed"
}

# Call the function with your desired USERNAME and password arguments
install_docker "docker" "docker_password"
