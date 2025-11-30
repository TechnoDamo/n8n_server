#!/bin/bash
set -e

# --------------------------
# Source config.env safely
# --------------------------
SCRIPT_DIR="$(dirname "$(realpath "$0")")/.."
CONFIG_FILE="$SCRIPT_DIR/config.env"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: config.env not found at $CONFIG_FILE"
    exit 1
fi
source "$CONFIG_FILE"

# --------------------------
# Docker network
# --------------------------
if ! docker network ls | grep -q '^web'; then
    docker network create web
fi

# --------------------------
# Paths
# --------------------------
REPO_DIR="$SCRIPT_DIR"
N8N_DIR="$REPO_DIR/n8n"
CADDY_DIR="$REPO_DIR/caddy"

# --------------------------
# Run Docker Compose
# --------------------------
cd "$N8N_DIR"
docker compose up -d --remove-orphans --env-file "$CONFIG_FILE"

cd "$CADDY_DIR"
docker compose up -d --remove-orphans --env-file "$CONFIG_FILE"

echo "n8n and Caddy containers are up and running!"
