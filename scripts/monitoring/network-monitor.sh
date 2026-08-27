#!/bin/bash
# Network monitoring
# Checks connectivity and logs issues

TARGETS="${@:-8.8.8.8 1.1.1.1}"
LOG_FILE="/var/log/network-monitor.log"

echo "=== Network Monitor ==="
echo "Date: $(date)"

for target in $TARGETS; do
    if ping -c 1 -W 2 "$target" >/dev/null 2>&1; then
        echo "[OK] $target reachable"
    else
        echo "[FAIL] $target unreachable"
        echo "$(date): $target unreachable" >> "$LOG_FILE"
    fi
done
