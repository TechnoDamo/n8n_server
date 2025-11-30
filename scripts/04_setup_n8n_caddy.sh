#!/bin/bash
set -e

# --------------------------
# Resolve repo and load config
# --------------------------
SCRIPT_DIR="$(dirname "$(realpath "$0")")/.."
CONFIG_FILE="$SCRIPT_DIR/config.env"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: config.env not found at $CONFIG_FILE"
    exit 1
fi

# Export all variables from config.env so Docker Compose can use them
set -o allexport
source "$CONFIG_FILE"
set +o allexport

# --------------------------
# Docker network (idempotent)
# --------------------------
if ! docker network inspect web >/dev/null 2>&1; then
    echo "Creating Docker network 'web'..."
    docker network create web
else
    echo "Docker network 'web' already exists. Skipping..."
fi

# --------------------------
# Directories
# --------------------------
N8N_DIR="$SCRIPT_DIR/n8n"
CADDY_DIR="$SCRIPT_DIR/caddy"

# --------------------------
# Remove old containers if they exist (idempotent)
# --------------------------
echo "Stopping and removing existing containers if any..."
docker compose -f "$N8N_DIR/docker-compose.yml" down --remove-orphans || true
docker compose -f "$CADDY_DIR/docker-compose.yml" down --remove-orphans || true

# --------------------------
# Run Docker Compose for n8n
# --------------------------
echo "Starting n8n container..."
cd "$N8N_DIR"
docker compose up -d

# --------------------------
# Run Docker Compose for Caddy
# --------------------------
echo "Starting Caddy container..."
cd "$CADDY_DIR"
docker compose up -d

echo "✅ n8n and Caddy are up and running!"
