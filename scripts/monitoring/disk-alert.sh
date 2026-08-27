#!/bin/bash
# Disk Space Alert
# Check disk usage and alert if threshold exceeded

set -euo pipefail

THRESHOLD="${1:-80}"
ALERT_FILE="/tmp/disk-alert-sent"

# Check all mounted filesystems
df -H | grep -vE "Filesystem|tmpfs|udev" | awk '{print $5 " " $6}' | while read usage mount; do
    USAGE_NUM=${usage%\%}
    if [ "$USAGE_NUM" -ge "$THRESHOLD" ]; then
        MSG="DISK ALERT: ${mount} is ${usage} full (threshold: ${THRESHOLD}%)"
        echo "$MSG"
        
        # Send Telegram alert if configured
        if [ -f "$ALERT_FILE" ]; then
            LAST_ALERT=$(stat -c %Y "$ALERT_FILE" 2>/dev/null || echo 0)
            NOW=$(date +%s)
            # Only alert once per hour
            if [ $((NOW - LAST_ALERT)) -lt 3600 ]; then
                continue
            fi
        fi
        
        if [ -n "${TELEGRAM_BOT_TOKEN:-}" ] && [ -n "${TELEGRAM_CHAT_ID:-}" ]; then
            curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage"                 -d "chat_id=${TELEGRAM_CHAT_ID}"                 -d "text=${MSG}" > /dev/null
            touch "$ALERT_FILE"
        fi
    fi
done
