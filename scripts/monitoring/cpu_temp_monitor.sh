#!/bin/bash
# CPU Temperature Monitor
# Reads CPU temperature and logs alerts if threshold exceeded

THRESHOLD=70
LOG_FILE="/var/log/cpu_temp.log"

while true; do
    if [ -f /sys/class/thermal/thermal_zone0/temp ]; then
        TEMP=$(cat /sys/class/thermal/thermal_zone0/temp)
        TEMP_C=$((TEMP / 1000))
        TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
        
        if [ "$TEMP_C" -gt "$THRESHOLD" ]; then
            echo "[$TIMESTAMP] ALERT: CPU temp ${TEMP_C}C exceeds threshold ${THRESHOLD}C" | tee -a "$LOG_FILE"
        else
            echo "[$TIMESTAMP] OK: CPU temp ${TEMP_C}C"
        fi
    fi
    sleep 60
done
