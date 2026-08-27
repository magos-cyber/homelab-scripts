# Homelab Scripts

Complete toolkit for homelabing — best-practice scripts, Docker Compose stacks, Proxmox/LXC automation & service configurations.

## 📁 Structure

```
homelab-scripts/
├── scripts/
│   ├── bash/           # Bash automation scripts
│   ├── python/         # Python utilities
│   └── monitoring/     # Monitoring & alerting
├── docker-compose/
│   ├── media/          # Media servers (Plex, Jellyfin, etc.)
│   ├── monitoring/     # Monitoring stacks
│   ├── network/        # Networking tools
│   └── utils/          # Utility services
├── proxmox/
│   ├── templates/      # VM/LXC templates
│   ├── backup/         # Backup scripts
│   └── network/        # Network configs
├── configs/
│   ├── nginx/          # Nginx reverse proxy configs
│   ├── systemd/        # Systemd service files
│   └── security/       # Security hardening
└── docs/               # Documentation
```

## 🚀 Quick Start

```bash
# Clone the repo
git clone git@github.com:magos-cyber/homelab-scripts.git
cd homelab-scripts

# Make scripts executable
chmod +x scripts/bash/*.sh
chmod +x scripts/python/*.py
```

## 📝 Contents

### Scripts
- `scripts/bash/server-setup.sh` — Initial setup for new Debian/Ubuntu server
- `scripts/bash/docker-install.sh` — Install Docker & Docker Compose
- `scripts/bash/auto-update.sh` — Auto-update services
- `scripts/python/disk-monitor.py` — Disk monitoring with Telegram alerts
- `scripts/monitoring/temp-alert.sh` — CPU temperature alerting

### Docker Compose
- `docker-compose/media/` — Plex, Jellyfin, Sonarr, Radarr
- `docker-compose/monitoring/` — Prometheus, Grafana, Uptime Kuma
- `docker-compose/network/` — Pi-hole, WireGuard, Traefik
- `docker-compose/utils/` — Portainer, Vaultwarden, Homer

### Proxmox
- `proxmox/templates/` — Cloud-init templates
- `proxmox/backup/` — Backup automation scripts
- `proxmox/network/` — Network configuration examples

### Configs
- `configs/nginx/` — Reverse proxy configurations
- `configs/systemd/` — Service files for auto-start
- `configs/security/` — Fail2ban, UFW rules

## 🤝 Contributing

Contributions are welcome! Open an issue or pull request.

## 📜 License

MIT License - see [LICENSE](LICENSE) for details.