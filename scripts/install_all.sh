#!/bin/bash
set -e

# --------------------------
# Resolve repo folder
# --------------------------
REPO_DIR="$(dirname "$(realpath "$0")")/.."
CONFIG_FILE="$REPO_DIR/config.env"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: config.env not found at $CONFIG_FILE"
    exit 1
fi
source "$CONFIG_FILE"

# --------------------------
# Ask user for installation type
# --------------------------
echo "Do you want to run installation under a NEW user? (y/n)"
read -r CREATE_NEW_USER

if [[ "$CREATE_NEW_USER" =~ ^[Yy]$ ]]; then
    echo "Creating new user: $NEW_USER"
    bash "$REPO_DIR/scripts/01_create_user.sh"

    USER_HOME="/home/$NEW_USER"
    TARGET_DIR="$USER_HOME/n8n_server"

    # Remove old copy if exists
    if [ -d "$TARGET_DIR" ]; then
        echo "Target directory $TARGET_DIR exists. Removing old copy..."
        sudo rm -rf "$TARGET_DIR"
    fi
    MY_UID=$(id -u $NEW_USER)
    MY_GID=$(id -g $NEW_USER)

    # Update config.env
    sed -i "s/^MY_UID=.*/MY_UID=$MY_UID/" "$CONFIG_FILE"
    sed -i "s/^MY_GID=.*/MY_GID=$MY_GID/" "$CONFIG_FILE"

    # Copy repo to new user's home
    echo "Copying repo to $TARGET_DIR..."
    sudo cp -r "$REPO_DIR" "$TARGET_DIR"
    sudo chown -R "$NEW_USER:$NEW_USER" "$TARGET_DIR"

    # Ensure n8n data folder exists with correct permissions
    N8N_DATA_DIR="$USER_HOME/.n8n"
    mkdir -p "$N8N_DATA_DIR"
    sudo chown -R "$NEW_USER:$NEW_USER" "$N8N_DATA_DIR"

    # Run remaining scripts as new user
    echo "Running remaining scripts as $NEW_USER..."
    sudo -u "$NEW_USER" bash -c "
cd $TARGET_DIR/scripts
./02_install_docker.sh
./03_install_docker_compose.sh
./04_setup_n8n_caddy.sh
"

else
    echo "Running installation under the CURRENT user: $USER"
    
    # Ensure n8n data folder exists with correct permissions
    N8N_DATA_DIR="$HOME/.n8n"
    mkdir -p "$N8N_DATA_DIR"
    sudo chown -R "$USER:$USER" "$N8N_DATA_DIR"

    cd "$REPO_DIR/scripts"
    ./02_install_docker.sh
    ./03_install_docker_compose.sh
    ./04_setup_n8n_caddy.sh
fi

echo "Installation completed successfully!"
