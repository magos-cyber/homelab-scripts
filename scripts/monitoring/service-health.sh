#!/bin/bash
# Service Health Check
# Check if critical services are running

set -euo pipefail

SERVICES="${@:-docker ssh cron}"
FAILED=0

echo "=== Service Health Check ==="
echo "Date: $(date)"
echo ""

for service in $SERVICES; do
 if systemctl is-active --quiet "$service" 2>/dev/null; then
 echo " $service: running"
 else
 echo " $service: NOT running"
 FAILED=$((FAILED + 1))
 
 # Try to restart
 echo " Attempting restart..."
 sudo systemctl restart "$service" 2>/dev/null && echo " Restarted" || echo " Restart failed"
 fi
done

echo ""
if [ $FAILED -eq 0 ]; then
 echo "All services healthy"
else
 echo "$FAILED service(s) had issues"
fi
exit $FAILED
