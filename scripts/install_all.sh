#!/bin/bash

# Load config
source ../config.env

# 1️⃣ Create user (idempotent)
bash ./01_create_user.sh
echo "User setup complete."

# 2️⃣ Run remaining scripts as the new user
sudo -u "$NEW_USER" bash -c "
cd ~/n8n_server/scripts
./02_install_docker.sh
./03_install_docker_compose.sh
./04_setup_n8n_caddy.sh
"
