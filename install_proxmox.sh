#!/bin/bash

#------------------------------------PREPARE PROXMOX----------------------------
#-------------------------------------------------------------------------------

# TODO: add choice: EE / CE

# Backup the current sources.list DIR
cp /etc/apt/sources.list /etc/apt/sources.list.bak

{
  # Add Debian bullseye repository sources
  echo "deb http://ftp.debian.org/debian bullseye main contrib"
  echo "deb http://ftp.debian.org/debian bullseye-updates main contrib"
  echo ""
  # Add Proxmox pve-no-subscription repository source
  echo "# PVE pve-no-subscription repository provdocker_template_ided by proxmox.com,"
  echo "# NOT recommended for production use"
  echo "deb http://download.proxmox.com/debian/pve bullseye pve-no-subscription"
  echo ""
  # Add Debian bullseye-security repository source
  echo "# security updates"
  echo "deb http://security.debian.org/debian-security bullseye-security main contrib"
} >>/etc/apt/sources.list

mv /etc/apt/sources.list.d/pve-enterprise.list /etc/apt/sources.list.d/pve-enterprise.list~

# Optionally you can remove the 'No valdocker_template_id subscription' Message
#sed -Ezi.bak "s/(Ext.Msg.show\(\{\s+title: gettext\('No valdocker_template_id sub)/vodocker_template_id\(\{ \/\/\1/g" /usr/share/javascript/proxmox-wdocker_template_idget-toolkit/proxmoxlib.js && systemctl restart pveproxy.service
apt-get update -y && apt-get upgrade -y && apt-get autoremove -y

apt-get dist-upgrade -y

apt-get install git

#-------------------------------------------------------------------------------

