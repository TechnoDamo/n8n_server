#!/bin/bash
source ../config.env

# Create user and add to sudo
sudo adduser --disabled-password --gecos "" $NEW_USER
echo "$NEW_USER:$USER_PASSWORD" | sudo chpasswd
sudo usermod -aG sudo,docker $NEW_USER
echo "User $NEW_USER created and added to sudo & docker groups"

