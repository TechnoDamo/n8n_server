#!/bin/bash
source ../config.env

# Create Docker network
docker network create web || true

# Copy docker-compose files to home
mkdir -p /home/$NEW_USER/n8n
cp ../n8n/docker-compose.n8n.yml /home/$NEW_USER/n8n/docker-compose.yml
cp ../caddy/Caddyfile /home/$NEW_USER/caddy/Caddyfile
mkdir -p /home/$NEW_USER/caddy
cp ../caddy/docker-compose.caddy.yml /home/$NEW_USER/caddy/docker-compose.yml

# Replace placeholders in n8n Compose file
sed -i "s|yourdomain.com|$DOMAIN|g" /home/$NEW_USER/n8n/docker-compose.yml
sed -i "s|admin|$N8N_USER|g" /home/$NEW_USER/n8n/docker-compose.yml
sed -i "s|strongpassword|$N8N_PASSWORD|g" /home/$NEW_USER/n8n/docker-compose.yml

# Run n8n and Caddy
cd /home/$NEW_USER/n8n && docker compose up -d
cd /home/$NEW_USER/caddy && docker compose up -d

