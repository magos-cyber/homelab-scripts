#!/bin/bash
# Load Average Alert
# Sends alert if load average exceeds threshold

THRESHOLD="${1:-4.0}"
LOG_FILE="/var/log/load-alert.log"

load=$(cat /proc/loadavg | awk '{print $1}')

if awk "BEGIN {exit !($load > $THRESHOLD)}"; then
    echo "[$(date)] HIGH LOAD: $load (> $THRESHOLD)" | tee -a "$LOG_FILE"
    # Optional: send to webhook
    # curl -X POST "$WEBHOOK_URL" -d "text=High load: $load"
fi
