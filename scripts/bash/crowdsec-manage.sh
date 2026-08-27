#!/bin/bash
# CrowdSec Management Script
# Manage CrowdSec bouncers, scenarios, and alerts

set -euo pipefail

CROWDSEC="cscli"

case "${1:-help}" in
    status)
        echo "=== CrowdSec Status ==="
        $CROWDSEC metrics
        ;;
    alerts)
        echo "=== Active Alerts ==="
        $CROWDSEC alerts list
        ;;
    bouncers)
        echo "=== Registered Bouncers ==="
        $CROWDSEC bouncers list
        ;;
    scenarios)
        echo "=== Installed Scenarios ==="
        $CROWDSEC scenarios list
        ;;
    ban)
        IP="${2:?Usage: $0 ban <ip>}"
        $CROWDSEC decisions add --ip "$IP" --duration 24h --reason "manual ban"
        echo "Banned $IP for 24h"
        ;;
    unban)
        IP="${2:?Usage: $0 unban <ip>}"
        $CROWDSEC decisions delete --ip "$IP"
        echo "Unbanned $IP"
        ;;
    reload)
        sudo systemctl restart crowdsec
        echo "CrowdSec restarted"
        ;;
    *)
        echo "Usage: $0 {status|alerts|bouncers|scenarios|ban|unban|reload}"
        ;;
esac
