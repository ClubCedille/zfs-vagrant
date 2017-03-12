#!/bin/bash

# Autheur: Marc-Antoine Carriere <purema4@gmail.com> 'https://github.com/purema4/zfs-vagrant'

if [ "$EUID" -ne "0"]
	then sudo -i
fi

#Adding backports repo to the source list

echo "deb http://ftp.debian.org/debian jessie-backports main contrib" >> /etc/apt/sources.list.d/backports.list
apt-get update

#Upgrading linux headers
apt-get install -y linux-headers-$(uname -r)

#Installing zfs
apt-get install -y -t jessie-backports zfs-dkms

#Confirm installation

printf "Installation de zfs done"
whereis zpool
whereis zfs
