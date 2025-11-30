#!/bin/bash

# Resolve repo folder dynamically
REPO_DIR="$(dirname "$(realpath "$0")")/.."

# Load config from repo
CONFIG_FILE="$REPO_DIR/config.env"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: config.env not found at $CONFIG_FILE"
    exit 1
fi
source "$CONFIG_FILE"

echo "Do you want to run the installation under a NEW user? (y/n)"
read -r CREATE_NEW_USER

if [[ "$CREATE_NEW_USER" =~ ^[Yy]$ ]]; then
    echo "Creating new user: $NEW_USER"
    # 1️⃣ Create the user
    bash "$REPO_DIR/scripts/01_create_user.sh"

    # 2️⃣ Copy repo to new user's home
    USER_HOME="/home/$NEW_USER"
    TARGET_DIR="$USER_HOME/n8n_server"

    if [ -d "$TARGET_DIR" ]; then
        echo "Target directory $TARGET_DIR exists. Removing old copy."
        sudo rm -rf "$TARGET_DIR"
    fi

    echo "Copying repo to $TARGET_DIR ..."
    sudo cp -r "$REPO_DIR" "$TARGET_DIR"

    # 3️⃣ Change ownership to new user
    sudo chown -R "$NEW_USER:$NEW_USER" "$TARGET_DIR"

    # 4️⃣ Run remaining scripts as new user
    sudo -u "$NEW_USER" bash -c "
cd $TARGET_DIR/scripts
./02_install_docker.sh
./03_install_docker_compose.sh
./04_setup_n8n_caddy.sh
"

else
    echo "Running installation under the CURRENT user: $USER"
    # Run remaining scripts directly
    bash "$REPO_DIR/scripts/02_install_docker.sh"
    bash "$REPO_DIR/scripts/03_install_docker_compose.sh"
    bash "$REPO_DIR/scripts/04_setup_n8n_caddy.sh"
fi
