#!/bin/bash

# Resolve repo folder dynamically
REPO_DIR="$(dirname "$(realpath "$0")")/.."

# Load config.env
CONFIG_FILE="$REPO_DIR/config.env"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: config.env not found at $CONFIG_FILE"
    exit 1
fi
source "$CONFIG_FILE"

# Verify variables
if [ -z "$NEW_USER" ] || [ -z "$USER_PASSWORD" ]; then
    echo "Error: NEW_USER or USER_PASSWORD not set in $CONFIG_FILE"
    exit 1
fi

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
