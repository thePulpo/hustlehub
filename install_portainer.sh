#!/bin/bash

ID_PORTAINER_AGENT=200
ID_PORTAINER=100

#-------------------------------------------------------------------------------

# Download Ubuntu Image
image=ubuntu-22.04-standard_22.04-1_amd64.tar.zst
pveam download local $image

#-------------------------------------------------------------------------------

#STORAGE="user_data"

# Set shared storage
#pvesm add dir $STORAGE --path /mnt/pve/$STORAGE
# Set LXC (root) as owner to gain full access
#chown 100000 /mnt/pve/$STORAGE
# To add a mountpoint to a lxc use:
#pct set -mp0 /mnt/pve/$STORAGE,mp=/home

#-------------------------------Create docker-template--------------------------
#-------------------------------------------------------------------------------

# The name of the new Container
HOSTNAME="portainer-agent"
# The ID of the new Container
ID=$ID_PORTAINER_AGENT
# The DIR of the installation files
DIR="./docker"
# Set the docker user name
#USERNAME="docker"
#PASSWORD="docker"

# Create the container
pct create $ID local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst \
  --hostname $HOSTNAME \
  --rootfs local-lvm:8 \
  --password hustlehub \
  --cores 1 \
  --memory 512 \
  --swap 512 \
  --unprivileged 1 \
  --features nesting=1 \
  --net0 name=eth0,bridge=vmbr0,firewall=1,ip=dhcp,ip6=dhcp \
  --onboot 1 \
  --start 0   # don't start the container immediately

# Start the container
pct start $ID
# Wait until the container is started
while [ "$(pct status $ID | grep 'status' | awk '{print $2}')" != "running" ]; do
  sleep 1
done

# pre docker install
#pct exec $ID -- bash -c "useradd -m -s /bin/bash -p \$(openssl passwd -1 $PASSWORD) $USERNAME"

# Loop through all files in the DIR
for FILE in "$DIR"/*; do
  # Get the filename without the path
  FILENAME=$(basename "$FILE")

  # Push the file to the container
  pct push $ID "$FILE" "/tmp/$FILENAME"
done
# Execute the installation files on the container
pct exec $ID -- su -c "/bin/bash /tmp/install.sh" root & wait

#------------------------------Install Portainer--------------------------------
# docker inspect --format '{{json .Spec.TaskTemplate.ContainerSpec.Env}}' stack_name | jq '.[]' | tr -d '"'
#-------------------------------------------------------------------------------

# The name of the new Container
HOSTNAME="portainer"
# The ID of the new Container
ID=$ID_PORTAINER
# The User Name
#USERNAME="docker"
# The DIR of the installation files
DIR="./$HOSTNAME"

# Stop the container
pct stop $ID_PORTAINER_AGENT
# Wait until the container is stopped
while [ "$(pct status $ID_PORTAINER_AGENT | grep 'status' | awk '{print $2}')" = "running" ]; do
  sleep 1
done

echo "CLONING CONTAINER..."
# Clone the Docker Template
pct clone $ID_PORTAINER_AGENT $ID_PORTAINER \
  --hostname "$HOSTNAME" \
  --full &
  wait
echo "CLONED CONTAINER!"

# Start the container
pct start $ID_PORTAINER
# Wait until the container is started
while [ "$(pct status $ID_PORTAINER | grep 'status' | awk '{print $2}')" != "running" ]; do
  sleep 1
done

# Loop through all files in the DIR
for FILE in "$DIR"/*; do
  # Get the filename without the path
  FILENAME=$(basename "$FILE")

  # Push the file to the container
  pct push $ID_PORTAINER "$FILE" "/tmp/$FILENAME"
done
# Execute the installation files on the container
pct exec $ID_PORTAINER -- su -c "/bin/bash /tmp/install.sh" "docker"


#------------------------------Finish Docker Template---------------------------
#-------------------------------------------------------------------------------

# Start the container
pct start $ID_PORTAINER_AGENT
# Wait until the container is started
while [ "$(pct status $ID_PORTAINER_AGENT | grep 'status' | awk '{print $2}')" != "running" ]; do
  sleep 1
done

# Deploy Portainer Agent
pct exec $ID_PORTAINER_AGENT -- su -c "docker run -d \
  -p 9001:9001 \
  --name portainer_agent \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /var/lib/docker/volumes:/var/lib/docker/volumes \
  portainer/agent:2.17.1" docker

pct stop $ID_PORTAINER_AGENT
# Wait until the container is stopped
while [ "$(pct status $ID_PORTAINER_AGENT | grep 'status' | awk '{print $2}')" = "running" ]; do
  sleep 1
done

pct template $ID_PORTAINER_AGENT

#---------------------------Create ---------------------------------------------
#-------------------------------------------------------------------------------




#-------------------------------------------------------------------------------

echo "Proxmox installation completed"

