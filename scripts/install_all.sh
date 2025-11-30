#!/bin/bash

# Run scripts in sequence
bash ./01_create_user.sh
echo "User created"

# Switch to the new user for the rest
sudo -i -u $NEW_USER bash << EOF
cd ~/scripts
bash 02_install_docker.sh
bash 03_install_docker_compose.sh
bash 04_setup_n8n_caddy.sh
EOF

