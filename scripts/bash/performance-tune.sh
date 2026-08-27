#!/usr/bin/env bash
# performance-tune.sh — Kernel & system performance tuning script for homelab nodes
# Usage: sudo bash performance-tune.sh

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
log() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }
header() { echo -e "\n${BLUE}=== $1 ===${NC}"; }

if [[ $EUID -ne 0 ]]; then
   error "This script must be run as root (sudo)"
fi

log "Starting system performance tuning..."

header "1. Swappiness & Memory Management"
CURRENT_SWAP=$(cat /proc/sys/vm/swappiness)
log "Current swappiness: $CURRENT_SWAP"
read -rp "Set VM swappiness to recommended homelab value (10)? [y/N]: " SET_SWAP
if [[ "${SET_SWAP,,}" =~ ^y ]]; then
    sysctl vm.swappiness=10
    # Make persistent
    if grep -q "^vm.swappiness" /etc/sysctl.conf; then
        sed -i 's/^vm.swappiness.*/vm.swappiness = 10/' /etc/sysctl.conf
    else
        echo "vm.swappiness = 10" >> /etc/sysctl.conf
    fi
    log "Swappiness set to 10 and persisted."
fi

header "2. File Descriptors & Inotify Limits (Great for Docker/K8s/Media Servers)"
log "Increasing max open file descriptors and inotify watches..."
cat > /etc/sysctl.d/99-homelab-performance.conf << 'EOF'
# Increase file descriptors limit system-wide
fs.file-max = 2097152

# Increase inotify watches for Docker, VS Code, Home Assistant, Plex
fs.inotify.max_user_watches = 524288
fs.inotify.max_user_instances = 512
fs.inotify.max_queued_events = 32768

# Virtual memory tuning
vm.swappiness = 10
vm.vfs_cache_pressure = 50
vm.dirty_background_ratio = 5
vm.dirty_ratio = 10

# Network stack performance / buffers
net.core.somaxconn = 1024
net.ipv4.tcp_max_syn_backlog = 8192
net.core.netdev_max_backlog = 5000
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216
net.ipv4.tcp_congestion_control = bbr
EOF

sysctl --system >/dev/null 2>&1
log "Kernel performance parameters applied via sysctl.d."

header "3. Limits for Open Files (pam_limits / limits.conf)"
if ! grep -q "nofile" /etc/security/limits.conf; then
    cat >> /etc/security/limits.conf << 'EOF'
* soft nofile 65536
* hard nofile 524288
root soft nofile 65536
root hard nofile 524288
EOF
    log "Updated /etc/security/limits.conf with high file descriptor limits."
else
    log "File descriptor limits already configured in limits.conf."
fi

header "4. Disk I/O Scheduler Check"
echo "--- Current Disk Schedulers ---"
for blk in /sys/block/sd* /sys/block/nvme*; do
    if [[ -d "$blk" ]]; then
        dev=$(basename "$blk")
        if [[ -f "$blk/queue/scheduler" ]]; then
            sched=$(cat "$blk/queue/scheduler")
            echo "  • $dev: $sched"
        fi
    fi
done

header "5. Summary of System Resources"
echo "--- CPU Info ---"
lscpu | grep -E "Model name|Socket|Core|Thread" || true
echo "--- Memory Info ---"
free -h || true

log "=========================================="
log "Performance tuning complete!"
log "=========================================="
log "Notes:"
log "  • TCP BBR congestion control enabled (if supported by kernel)."
log "  • Inotify watch limits raised for Docker/homelab containers."
log "  • Swappiness tuned to 10 to favor RAM usage over swap."
