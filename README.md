# 🚀 n8n Server Setup

![n8n](https://raw.githubusercontent.com/n8n-io/n8n/master/assets/n8n-logo.png)  

A simple and automated setup for **n8n** with **Caddy** as reverse proxy, designed to run on Ubuntu servers. Supports running under the current user or a newly created user.  

---

## ✨ Features

- Automated installation of:
  - Docker & Docker Compose
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

### 1. Installation

```bash
# --------------------------
# Step 0: Remove old n8n_server folder if it exists
# --------------------------
if [ -d "$HOME/n8n_server" ]; then
    echo "Removing existing n8n_server folder..."
    rm -rf "$HOME/n8n_server"
fi

# --------------------------
# Step 1: Clone the Repository
# --------------------------
git clone https://github.com/TechnoDamo/n8n_server.git
cd n8n_server

# --------------------------
# Step 2: Edit configuration
# --------------------------
nano config.env

# --------------------------
# Step 3: Start installation
# --------------------------
cd scripts
chmod +x *
sudo ./install_all.sh
```

