#!/usr/bin/env bash
# security-audit.sh — Basic security audit script for homelab nodes
# Usage: sudo bash security-audit.sh

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
log() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }
header() { echo -e "\n${BLUE}=== $1 ===${NC}"; }

if [[ $EUID -ne 0 ]]; then
   error "This script must be run as root (sudo)"
fi

log "Starting security audit..."

header "1. User & Account Checks"
echo "--- Users with UID 0 (Superusers) ---"
awk -F: '($3 == 0) {print $1}' /etc/passwd

echo "--- Users with empty passwords ---"
if awk -F: '($2 == "" ) {print $1}' /etc/shadow 2>/dev/null | grep -q .; then
    warn "Found accounts with empty passwords!"
    awk -F: '($2 == "" ) {print $1}' /etc/shadow
else
    log "No accounts with empty passwords found."
fi

echo "--- Sudoers (users in sudo/wheel group) ---"
getent group sudo || getent group wheel || true

header "2. SSH Configuration & Access Audit"
if [[ -f /etc/ssh/sshd_config ]]; then
    PERMIT_ROOT=$(grep -i "^PermitRootLogin" /etc/ssh/sshd_config || echo "Not explicitly set")
    PASS_AUTH=$(grep -i "^PasswordAuthentication" /etc/ssh/sshd_config || echo "Not explicitly set")
    PUBKEY_AUTH=$(grep -i "^PubkeyAuthentication" /etc/ssh/sshd_config || echo "Not explicitly set")
    
    echo "  • $PERMIT_ROOT"
    echo "  • $PASS_AUTH"
    echo "  • $PUBKEY_AUTH"

    if grep -q "^PermitRootLogin yes" /etc/ssh/sshd_config; then
        warn "Root login via SSH is enabled. Consider disabling it."
    else
        log "Root login via SSH appears disabled or restricted."
    fi
else
    warn "/etc/ssh/sshd_config not found."
fi

header "3. Firewall Status (UFW / IPTables)"
if command -v ufw &>/dev/null; then
    UFW_STATUS=$(ufw status | head -n 1)
    log "UFW Status: $UFW_STATUS"
    ufw status verbose || true
else
    warn "UFW is not installed."
fi

header "4. Active Services & Listening Ports"
if command -v ss &>/dev/null; then
    log "Listening network sockets (TCP/UDP):"
    ss -tulpn | grep LISTEN || true
else
    warn "ss command not available."
fi

header "5. Failed Login Attempts / Fail2Ban"
if systemctl is-active --quiet fail2ban; then
    log "Fail2ban service is active."
    if command -v fail2ban-client &>/dev/null; then
        echo "--- Fail2ban Jails Status ---"
        fail2ban-client status || true
    fi
else
    warn "Fail2ban service is NOT active or not installed."
fi

echo "--- Recent failed SSH login attempts in auth.log ---"
if [[ -f /var/log/auth.log ]]; then
    grep -i "Failed password" /var/log/auth.log | tail -n 10 || echo "None found or log inaccessible."
elif [[ -f /var/log/secure ]]; then
    grep -i "Failed password" /var/log/secure | tail -n 10 || echo "None found or log inaccessible."
else
    warn "Auth log file not found."
fi

header "6. Sensitive File Permissions"
check_perm() {
    local file="$1"
    local expected="$2"
    if [[ -e "$file" ]]; then
        local current
        current=$(stat -c "%a" "$file" 2>/dev/null || stat -f "%A" "$file" 2>/dev/null)
        if [[ "$current" -le "$expected" ]]; then
            echo -e "  • $file permissions ($current): ${GREEN}SECURE${NC}"
        else
            echo -e "  • $file permissions ($current): ${YELLOW}LOOSE (recommend <= $expected)${NC}"
        fi
    fi
}

check_perm "/etc/shadow" 600
check_perm "/etc/gshadow" 600
check_perm "/etc/passwd" 644
check_perm "/etc/group" 644

header "7. Pending Security Updates"
if command -v apt-get &>/dev/null; then
    log "Checking for upgradable packages..."
    apt-get -s upgrade 2>/dev/null | grep -i security || log "No explicit security summary available via dry-run."
fi

log "=========================================="
log "Security audit complete!"
log "=========================================="
