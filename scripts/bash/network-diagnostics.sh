#!/usr/bin/env bash
# network-diagnostics.sh — Comprehensive network troubleshooting for homelab nodes
# Usage: sudo bash network-diagnostics.sh [target_host]

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
log() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }
header() { echo -e "\n${BLUE}=== $1 ===${NC}"; }

# Default target for external checks if not specified
TARGET="${1:-8.8.8.8}"
LOCAL_GATEWAY=""

header "1. Local Network Interface & IP Configuration"
echo "--- IP Addresses ---"
ip -c a || ifconfig || true
echo "--- Routing Table ---"
ip route || route -n || true

# Determine default gateway
if command -v ip &>/dev/null; then
    LOCAL_GATEWAY=$(ip route show default 2>/dev/null | awk '/default/ {print $3}')
fi

header "2. DNS Resolution Check"
log "Testing DNS resolution for google.com and local gateway..."
if host google.com &>/dev/null; then
    log "DNS resolution (host google.com): OK"
    host google.com
elif nslookup google.com &>/dev/null; then
    log "DNS resolution (nslookup google.com): OK"
    nslookup google.com
else
    warn "DNS resolution failed or tools missing."
fi

echo "--- /etc/resolv.conf ---"
cat /etc/resolv.conf || true

header "3. Connectivity & Ping Tests"
log "Ping target: $TARGET (3 packets)"
if ping -c 3 -W 2 "$TARGET" &>/dev/null; then
    log "External ping to $TARGET: SUCCESS"
    ping -c 3 -W 2 "$TARGET"
else
    warn "External ping to $TARGET failed or timed out."
fi

if [[ -n "${LOCAL_GATEWAY}" ]]; then
    log "Ping local gateway ($LOCAL_GATEWAY) (3 packets)"
    if ping -c 3 -W 2 "$LOCAL_GATEWAY" &>/dev/null; then
        log "Gateway ping: SUCCESS"
        ping -c 3 -W 2 "$LOCAL_GATEWAY"
    else
        warn "Gateway ping to $LOCAL_GATEWAY failed."
    fi
else
    warn "Local gateway IP could not be automatically determined."
fi

header "4. Traceroute / Path Diagnostics"
if command -v traceroute &>/dev/null; then
    log "Running traceroute to $TARGET (max 15 hops)..."
    traceroute -m 15 -w 2 "$TARGET" || true
elif command -v tracepath &>/dev/null; then
    log "Running tracepath to $TARGET..."
    tracepath -m 15 "$TARGET" || true
else
    warn "Neither traceroute nor tracepath is installed."
fi

header "5. Listening Ports & Local Services"
if command -v ss &>/dev/null; then
    log "Active listening ports (ss -tulpn):"
    ss -tulpn || true
elif command -v netstat &>/dev/null; then
    log "Active listening ports (netstat -tulpn):"
    netstat -tulpn || true
else
    warn "Neither ss nor netstat available."
fi

header "6. Common Homelab Service Port Checks"
# Check typical internal/external ports on localhost or standard gateway if desired
PORTS=(22 53 80 443 3000 8080 9000)
for port in "${PORTS[@]}"; do
    if nc -z -w 1 127.0.0.1 "$port" 2>/dev/null; then
        echo -e "  Port ${port}: ${GREEN}OPEN${NC} (localhost)"
    else
        echo -e "  Port ${port}: closed or filtered (localhost)"
    fi
done

header "7. Network Statistics & Errors"
if command -v ip &>/dev/null; then
    echo "--- Interface Error Stats ---"
    ip -s link || true
fi

log "=========================================="
log "Network diagnostics completed!"
log "=========================================="
