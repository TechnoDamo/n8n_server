# 🚀 n8n Server Setup

![n8n](https://raw.githubusercontent.com/n8n-io/n8n/master/assets/n8n-logo.png)  

A simple and automated setup for **n8n** with **Caddy** as reverse proxy, designed to run on Ubuntu servers. Supports running under the current user or a newly created user.  

---

## ✨ Features

- Automated installation of:
  - Podman & Podman Compose
  - n8n workflow automation
  - Caddy reverse proxy with automatic HTTPS
- Optional creation of a dedicated server user
- Idempotent scripts (safe to re-run)
- Centralized configuration via `config.env`
- Docker volumes for persistent data

---

## 📝 Prerequisites

- Ubuntu 20.04+ server
- SSH access
- Git installed
- Optional: sudo privileges
- Valid domain pointing to the servers IP

---

## ⚡ Quick Start
Write your values to the config.env and change damirkoblev.ru to your domain in caddy/Caddyfile.

### 1. Installation

```bash
# ----------------------------------------------------
# Install podman and podman-compose if not installed 
# ----------------------------------------------------

# Update system
sudo apt update && sudo apt upgrade -y

# Install Podman
sudo apt install -y podman

# Install podman-compose
sudo apt install -y podman-compose

# Configure rootless mode
echo "kernel.unprivileged_userns_clone=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# Verify installation
podman --version
podman-compose --version
echo "Podman installation complete!"
```
```bash
# --------------------------
# Create new user (optional)
# --------------------------
export NEW_USER="${NEW_USER:-n8n_admin}"  # Default value if not set

echo "Creating user: $NEW_USER"

sudo useradd -m -s /bin/bash $NEW_USER
sudo passwd $NEW_USER

sudo mkdir -p /home/$NEW_USER/.ssh
sudo echo "YOUR_PUBLIC_SSH_KEY" | sudo tee /home/$NEW_USER/.ssh/authorized_keys
sudo chown -R $NEW_USER:$NEW_USER /home/$NEW_USER/.ssh
sudo chmod 700 /home/$NEW_USER/.ssh
sudo chmod 600 /home/$NEW_USER/.ssh/authorized_keys

echo "User $NEW_USER created successfully!"

# Add to sudo group
sudo usermod -aG sudo $NEW_USER

# Switch to the new user
echo "Switching to user $NEW_USER..."
sudo su - $NEW_USER
```
```bash
# --------------------------
# Step 3: Start installation
# --------------------------
git clone https://github.com/TechnoDamo/n8n_server.git
cd n8n_server
sudo kill -9 $(sudo lsof -t -i:5678)
podman network create web
podman pull docker.io/n8nio/n8n:latest
podman pull docker.io/caddy:latest
sudo podman-compose --env-file config.env -f n8n/docker-compose.yml -f caddy/docker-compose.yml up -d
```

