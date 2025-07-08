# Odoo 18 Dockerized Environment (Testing Only)

This project sets up a Dockerized instance of **Odoo 18** for testing and development purposes only.

## 📁 Directory Structure

- `addons/` — Contains the `community`, `custom_addons`, and `enterprise` modules
- `config/odoo.conf` — Main Odoo configuration file
- `outputs/` — Folder for logs or exports
- `filestore/` — (optional) Used to store binary files for Odoo databases
- `Dockerfile` — Custom Odoo 18 build with additional tools and pip packages
- `requirements.txt` — Python dependencies for custom modules
- `docker-compose.yaml` — Multi-container orchestration for Odoo and PostgreSQL

## ⚠️ Disclaimer

> **This setup is for internal testing and development only.**  
> It is not intended or secured for production use.

## 🐳 Quick Start

```bash
docker-compose up --build
