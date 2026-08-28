#!/bin/bash
# Firewall Audit Script
# Reviews iptables rules and common misconfigurations

echo "=== Firewall Audit ==="

# Check if iptables is installed
if ! command -v iptables &>/dev/null; then
    echo "ERROR: iptables not found"
    exit 1
fi

# List all rules
echo "--- Current Rules ---"
iptables -L -n -v

# Check for any allow-all rules
echo ""
echo "--- Checking for allow-all rules ---"
iptables -L INPUT -n | grep -E "ACCEPT.*0.0.0.0" && echo "WARNING: Allow-all rule found"

# Check default policies
echo ""
echo "--- Default Policies ---"
iptables -L | grep "Chain" | head -3

# Check for common ports
echo ""
echo "--- Common Ports ---"
for port in 22 80 443 3306 5432; do
    if iptables -L INPUT -n | grep -q "dpt:$port"; then
        echo "Port $port: configured"
    else
        echo "Port $port: not configured"
    fi
done
