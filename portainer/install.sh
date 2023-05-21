#!/bin/bash

# Set the hostname
hostname="portainer"

# Run docker-compose
docker compose -p "$hostname" -f /tmp/docker-compose.yml up -d
#docker compose -p "$hostname" up -d
