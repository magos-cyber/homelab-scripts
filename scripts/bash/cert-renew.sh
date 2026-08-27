#!/bin/bash
# SSL Certificate renewal with certbot
# Renews all certificates and reloads services

set -euo pipefail

SERVICES="${RELOAD_SERVICES:-nginx traefik}"

echo "=== SSL Certificate Renewal ==="

# Renew certificates
certbot renew --quiet

# Reload services
for svc in $SERVICES; do
    if systemctl is-active --quiet "$svc" 2>/dev/null; then
        echo "Reloading $svc..."
        systemctl reload "$svc"
    fi
done

echo "Certificate renewal complete"
