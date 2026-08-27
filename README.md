# Homelab Scripts

Complete toolkit for homelabing — best-practice scripts, Docker Compose stacks, Proxmox/LXC automation & service configurations. All content is in English to reach the global self-hosting community.

## 📁 Structure

```
homelab-scripts/
├── scripts/
│   ├── bash/           # Bash automation (server setup, docker, vpn, backup, security)
│   ├── python/         # Python utilities (disk monitor, port scanner)
│   └── monitoring/     # Monitoring & alerting (temp alert)
├── docker-compose/
│   ├── media/          # Jellyfin, *arr, Immich, Navidrome
│   ├── monitoring/     # Prometheus, Grafana, Uptime Kuma, cAdvisor, node-exporter
│   ├── network/        # Pi-hole, Traefik, AdGuard+Unbound
│   ├── utils/          # Portainer, Vaultwarden, Homer, Watchtower, Dozzle, IT-Tools, Stirling PDF
│   ├── home-assistant/ # Home Assistant + Mosquitto MQTT
│   ├── productivity/   # Nextcloud, Paperless-ngx, Gitea
│   ├── auth/           # Authentik identity server
│   └── databases/      # MariaDB, PostgreSQL, Redis shared stack
├── proxmox/
│   ├── templates/      # LXC cloud-init templates
│   └── backup/         # Backup automation scripts
├── configs/
│   ├── nginx/          # Reverse proxy examples
│   ├── systemd/        # Service files & timers (auto-update)
│   └── security/       # Baseline hardening scripts
├── .github/workflows/  # CI: shellcheck, yamllint, py-compile, compose validate
└── docs/               # Documentation
```

## 🚀 Quick Start

```bash
# Clone the repo
git clone https://github.com/magos-cyber/homelab-scripts.git
cd homelab-scripts

# Make scripts executable
chmod +x scripts/bash/*.sh scripts/python/*.py proxmox/backup/*.sh
```

## 📝 Contents

### Bash Scripts
- `scripts/bash/server-setup.sh` — Harden a fresh Debian/Ubuntu server (UFW, fail2ban, SSH, auto-updates)
- `scripts/bash/docker-install.sh` — Install Docker Engine + Compose with sane daemon defaults
- `scripts/bash/auto-update.sh` — Pull & recreate compose stacks, prune, health-check
- `scripts/bash/vpn-setup.sh` — WireGuard server + `wg-add-client.sh` helper
- `scripts/bash/backup-automator.sh` — Rotating tar.gz backups with optional Telegram notify
- `scripts/bash/security-hardening.sh` — Apply baseline firewall (UFW) + Fail2Ban + sysctl hardening
- `scripts/bash/hass-backup.sh` — Backup Home Assistant configuration (snapshot + rotation)
- `scripts/bash/hass-update.sh` — Pull latest Home Assistant image and restart container
- `scripts/monitoring/temp-alert.sh` — CPU temperature alerts via Telegram (state-aware)

### Python Utilities
- `scripts/python/disk-monitor.py` — Disk usage monitor with warning/critical thresholds + Telegram
- `scripts/python/port-scanner.py` — Multi-host TCP port scanner (common homelab ports)

### Docker Compose — Media
- `docker-compose/media/` — Jellyfin + *arr (Sonarr/Radarr) stack
- `docker-compose/media/immich/` — Immich photo management (PostgreSQL 15 + Redis + ML)
- `docker-compose/media/navidrome/` — Navidrome music streaming (Subsonic-compatible)

### Docker Compose — Monitoring
- `docker-compose/monitoring/` — Full Prometheus/Grafana/Uptime Kuma/cAdvisor/node-exporter stack with provisioning, dashboards, and alert rules

### Docker Compose — Network
- `docker-compose/network/` — Pi-hole DNS ad-blocker
- `docker-compose/network/traefik/` — Traefik v3 reverse proxy with Let's Encrypt (Cloudflare DNS-01), security headers, dashboard
- `docker-compose/network/dns/` — AdGuard Home + Unbound (DNS-over-TLS to Cloudflare/Quad9, DNSSEC)

### Docker Compose — Productivity
- `docker-compose/productivity/nextcloud/` — Nextcloud (PostgreSQL 15 + Redis + Cron)
- `docker-compose/productivity/paperless-ngx/` — Paperless-ngx document management (PostgreSQL + Redis + Gotenberg + Tika)
- `docker-compose/productivity/gitea/` — Gitea self-hosted Git (PostgreSQL 16, SSH on 2222)

### Docker Compose — Auth & IoT
- `docker-compose/auth/authentik/` — Authentik identity/authentication server (PostgreSQL + Redis, server + worker)
- `docker-compose/home-assistant/` — Home Assistant + Mosquitto MQTT

### Docker Compose — Utils & Databases
- `docker-compose/utils/` — Portainer, Vaultwarden, Homer
- `docker-compose/utils/utility.yml` — Watchtower (auto-update), Dozzle (logs), IT-Tools, Stirling PDF
- `docker-compose/databases/` — Shared MariaDB + PostgreSQL + Redis stack

### Proxmox
- `proxmox/templates/lxc-template.yml` — Documented LXC cloud-init template + `pct create` example
- `proxmox/backup/backup-script.sh` — Automated VM/LXC `vzdump` with retention + Telegram

### Configs
- `configs/nginx/example_proxy.conf` — Example Nginx reverse proxy for Jellyfin, Grafana, Portainer, Uptime Kuma (SSL ready)
- `configs/systemd/homelab-auto-update.service` — Systemd service to run the auto-update script
- `configs/systemd/homelab-auto-update.timer` — Timer to trigger the service daily at 04:00

## ✅ CI

The repository includes a GitHub Actions workflow at `.github/workflows/ci.yml` that runs on push and PR to main. It performs:
- Shellcheck on all bash scripts
- YAML validation on all compose files
- Python `py_compile` on all Python scripts
- `docker compose config` on every stack to ensure they are valid

## 🤝 Contributing

Contributions are welcome! Open an issue or pull request. Please keep scripts in English and add a short header comment describing usage.

## 📜 License

MIT License — see [LICENSE](LICENSE) for details.