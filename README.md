# Homelab Scripts

Collection of Bash scripts for homelab management, monitoring, and automation.

## Categories

### Monitoring
- `monitoring/cpu_temp_monitor.sh` - CPU temperature monitoring with alerts
- `monitoring/disk_health_check.sh` - SMART disk health checks
- `monitoring/bandwidth_monitor.sh` - Network bandwidth tracking
- `monitoring/service-watchdog.sh` - Automatic service restart on failure
- `monitoring/uptime-checker.sh` - Host availability monitoring
- `monitoring/load-alert.sh` - Load average alerts
- `monitoring/memory-monitor.sh` - Memory usage alerts

### Security
- `security/firewall_audit.sh` - iptables/ufw configuration review

### Automation
- `automation/update_all.sh` - System update automation

## Usage

```bash
# Make executable
chmod +x scripts/**/*.sh

# Run monitoring
./scripts/monitoring/cpu_temp_monitor.sh
```

## Requirements

- Bash 4+
- Standard Linux utilities (smartctl, ip, ss, systemctl)

## License

MIT
