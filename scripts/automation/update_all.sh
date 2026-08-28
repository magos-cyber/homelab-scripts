#!/bin/bash
# System Update Automation
# Updates package lists, upgrades packages, and cleans up

set -euo pipefail

LOG="/var/log/system_update.log"

echo "=== System Update $(date) ===" | tee "$LOG"

# Update package lists
echo "Updating package lists..." | tee -a "$LOG"
apt-get update 2>&1 | tee -a "$LOG"

# Upgrade packages
echo "Upgrading packages..." | tee -a "$LOG"
apt-get upgrade -y 2>&1 | tee -a "$LOG"

# Remove unused packages
echo "Cleaning up..." | tee -a "$LOG"
apt-get autoremove -y 2>&1 | tee -a "$LOG"
apt-get autoclean -y 2>&1 | tee -a "$LOG"

# Check if reboot required
if [ -f /var/run/reboot-required ]; then
    echo "REBOOT REQUIRED" | tee -a "$LOG"
fi

echo "Update complete" | tee -a "$LOG"
