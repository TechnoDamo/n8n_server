#!/bin/bash
# Load config
source ~/n8n_server/config.env

# Create Docker network if it doesn't exist
if ! docker network ls | grep -q '^web'; then
    docker network create web
fi

# Ensure directories exist (inside the repo)
mkdir -p ~/n8n_server/n8n ~/n8n_server/caddy

# Copy docker-compose files (no placeholders needed)
cp ~/n8n_server/n8n/docker-compose.yml ~/n8n_server/n8n/docker-compose.yml
cp ~/n8n_server/caddy/docker-compose.yml ~/n8n_server/caddy/docker-compose.yml
cp ~/n8n_server/caddy/Caddyfile ~/n8n_server/caddy/Caddyfile

# Make the new user the owner
sudo chown -R "$NEW_USER:$NEW_USER" ~/n8n_server

# Run n8n and Caddy as the new user with env-file
sudo -u "$NEW_USER" bash -c "
cd ~/n8n_server/n8n
docker compose --env-file ~/n8n_server/config.env up -d

cd ~/n8n_server/caddy
docker compose --env-file ~/n8n_server/config.env up -d
"
