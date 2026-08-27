# Homelab Scripts

Complete toolkit for homelabing — best-practice scripts, Docker Compose stacks, Proxmox/LXC automation & service configurations. All content is in English to reach the global self-hosting community.

## 📁 Structure

```
homelab-scripts/
├── scripts/
│   ├── bash/           # Bash automation (server setup, docker, vpn, backup)
│   ├── python/         # Python utilities (disk monitor, port scanner)
│   └── monitoring/     # Monitoring & alerting (temp alert)
├── docker-compose/
│   ├── media/          # Media servers (Jellyfin, Sonarr, Radarr)
│   ├── monitoring/     # Prometheus, Grafana, Uptime Kuma, cAdvisor, node-exporter
│   ├── network/        # Pi-hole, WireGuard
│   └── utils/          # Portainer, Vaultwarden, Homer
├── proxmox/
│   ├── templates/      # LXC cloud-init templates
│   └── backup/         # Backup automation scripts
├── configs/            # nginx / systemd / security (coming soon)
├── .github/workflows/  # CI: shellcheck, yamllint, py-compile, compose validate (requires PAT with workflow scope)
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
- `scripts/monitoring/temp-alert.sh` — CPU temperature alerts via Telegram (state-aware)

### Python Utilities
- `scripts/python/disk-monitor.py` — Disk usage monitor with warning/critical thresholds + Telegram
- `scripts/python/port-scanner.py` — Multi-host TCP port scanner (common homelab ports)

### Docker Compose
- `docker-compose/media/` — Jellyfin + *arr stack
- `docker-compose/monitoring/` — Full Prometheus/Grafana/Uptime Kuma/cAdvisor/node-exporter stack with provisioning
- `docker-compose/network/` — Pi-hole
- `docker-compose/utils/` — Uptime Kuma

### Proxmox
- `proxmox/templates/lxc-template.yml` — Documented LXC cloud-init template + `pct create` example
- `proxmox/backup/backup-script.sh` — Automated VM/LXC `vzdump` with retention + Telegram

## ✅ CI

The repository includes a GitHub Actions workflow at `.github/workflows/ci.yml` that runs on push and PR to main. It performs:
- Shellcheck on all bash scripts
- YAML validation on all compose files
- Python `py_compile` on all Python scripts
- `docker compose config` on every stack to ensure they are valid

**Note:** To enable this workflow, you need a Personal Access Token with the `workflow` scope. If your PAT does not have this scope, the workflow will not be created/updateable. You can still use all other features of the repo.

## 🤝 Contributing

Contributions are welcome! Open an issue or pull request. Please keep scripts in English and add a short header comment describing usage.

## 📜 License

MIT License — see [LICENSE](LICENSE) for details.