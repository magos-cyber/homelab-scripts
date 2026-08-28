#!/bin/bash
# Service Watchdog
# Monitors critical services and restarts if they fail

SERVICES="nginx postgresql redis docker"
LOG_FILE="/var/log/service-watchdog.log"

check_service() {
    if ! systemctl is-active --quiet "$1"; then
        echo "[$(date)] Service $1 is DOWN, restarting..." | tee -a "$LOG_FILE"
        systemctl restart "$1"
        sleep 3
        if systemctl is-active --quiet "$1"; then
            echo "[$(date)] $1 restarted OK" | tee -a "$LOG_FILE"
        else
            echo "[$(date)] FAILED to restart $1" | tee -a "$LOG_FILE"
        fi
    fi
}

echo "[$(date)] Watchdog started" | tee -a "$LOG_FILE"

while true; do
    for svc in $SERVICES; do
        check_service "$svc"
    done
    sleep 60
done
