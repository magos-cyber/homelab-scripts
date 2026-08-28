#!/bin/bash
# Disk Health Checker
# Checks SMART status of all disks

echo "=== Disk Health Check ==="

for disk in /dev/sd?; do
    echo ""
    echo "--- $disk ---"
    smartctl -H "$disk" 2>/dev/null || echo "SMART not available"
    
    # Check for pending sectors
    PENDING=$(smartctl -A "$disk" 2>/dev/null | grep "Current_Pending_Sector" | awk '{print $10}')
    if [ -n "$PENDING" ] && [ "$PENDING" -gt 0 ]; then
        echo "WARNING: $disk has $PENDING pending sectors"
    fi
done
