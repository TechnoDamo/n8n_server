#!/bin/bash

# Load config
source ~/n8n_server/config.env

# Check if user exists
if id "$NEW_USER" &>/dev/null; then
    echo "User $NEW_USER already exists. Skipping creation."
else
    echo "Creating user $NEW_USER ..."
    sudo adduser --disabled-password --gecos "" "$NEW_USER"
    echo "$NEW_USER:$USER_PASSWORD" | sudo chpasswd
    sudo usermod -aG sudo,docker "$NEW_USER"
    echo "User $NEW_USER created and added to sudo & docker groups."
fi
