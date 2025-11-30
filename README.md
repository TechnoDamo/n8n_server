# 🚀 n8n Server Setup

![n8n](https://raw.githubusercontent.com/n8n-io/n8n/master/assets/n8n-logo.png)  

A simple and automated setup for **n8n** with **Caddy** as reverse proxy, designed to run on Ubuntu servers.

---

## ✨ Features

- Automated installation of:
  - Docker & Docker Compose
  - n8n workflow automation
  - Caddy reverse proxy with automatic HTTPS
- Optional creation of a dedicated server user
- Centralized configuration via `config.env`
- Container-host data mapping for convenient backups

---

## 📝 Prerequisites

- Ubuntu 20.04+ server
- SSH access
- Git installed
- Sudo privileges
- Valid domain pointing to the servers IP

---

## 📁 Project Structure

```
n8n_server/
├── caddy # Caddy configuration folder
│   └── Caddyfile # Reverse proxy & SSL setup
├── n8n_data # Persistent storage for n8n workflows and credentials
├── docker-compose.yml # Docker Compose file to run n8n + Cadd
├── .env # Environment variables for n8n and services
└── README.md # Project documentation
```

## ⚡ Quick Start
Write your values to the .env and change damirkoblev.ru to your domain in caddy/Caddyfile.
```bash
# Bonus - if you need to stop or remove all existing containers on the system
sudo docker stop $(sudo docker ps -aq) 2>/dev/null
sudo docker rm $(sudo docker ps -aq) 2>/dev/null
```

### Installation

```bash
# ----------------------------------------------------
# Install docker and docker-compose if not installed 
# ----------------------------------------------------

# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
sudo apt install -y docker.io

# Enable Docker service
sudo systemctl enable --now docker

# Install Docker Compose plugin
sudo apt install -y docker-compose-plugin

# Verify installation
docker --version
docker compose version
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
# Add to docker group
sudo usermod -aG docker $NEW_USER

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
mkdir n8n_data
sudo chown -R 1000:1000 ~/n8n_server/n8n_data
sudo chmod -R 755 ~/n8n_server/n8n_data

# Start services
docker-compose up -d
```

## 🎉 Deployment Successful!

Your n8n instance is now running at: **https://N8N_HOST**

### What's Next?
- 🌐 Access your n8n dashboard
- 🔧 Start building automations
- 📚 Explore [n8n documentation](https://docs.n8n.io)
- 💬 Join the [n8n community](https://community.n8n.io)

**Happy automating! 🚀**