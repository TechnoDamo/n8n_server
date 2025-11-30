#!/bin/bash
DOCKER_COMPOSE_VERSION=$(grep DOCKER_COMPOSE_VERSION ../config.env | cut -d '=' -f2)

sudo curl -L "https://github.com/docker/compose/releases/download/v$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

