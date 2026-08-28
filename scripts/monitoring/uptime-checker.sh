#!/bin/bash
# Uptime Checker
# Pings hosts and logs availability

HOSTS="10.0.0.1 10.0.0.10 10.0.0.11 10.0.0.85 10.0.0.162"
LOG_FILE="/var/log/uptime.log"

echo "=== Uptime Check $(date) ===" | tee -a "$LOG_FILE"

for host in $HOSTS; do
    if ping -c 1 -W 2 "$host" &>/dev/null; then
        echo "$(date) $host UP" | tee -a "$LOG_FILE"
    else
        echo "$(date) $host DOWN" | tee -a "$LOG_FILE"
    fi
done
