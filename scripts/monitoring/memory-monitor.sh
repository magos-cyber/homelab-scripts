#!/bin/bash
# Memory Monitor
# Logs memory usage and alerts on low memory

THRESHOLD_PERCENT="${1:-90}"
LOG_FILE="/var/log/memory-monitor.log"

mem_used=$(free | grep Mem | awk '{printf("%.0f"), $3/$2 * 100}')

if [ "$mem_used" -gt "$THRESHOLD_PERCENT" ]; then
    echo "[$(date)] LOW MEMORY: ${mem_used}% used" | tee -a "$LOG_FILE"
    # Show top memory processes
    ps aux --sort=-%mem | head -5 >> "$LOG_FILE"
fi
