#!/bin/bash
# Log rotation script
# Rotates logs older than N days

LOG_DIR="${1:-/var/log}"
DAYS="${2:-30}"
SIZE="${3:-100M}"

echo "Rotating logs in $LOG_DIR older than $DAYS days..."

# Find and compress old logs
find "$LOG_DIR" -name "*.log" -mtime +$DAYS -exec gzip {} \;

# Find and delete very old compressed logs
find "$LOG_DIR" -name "*.gz" -mtime +$((DAYS * 2)) -delete

# Truncate large active logs
find "$LOG_DIR" -name "*.log" -size +$SIZE -exec sh -c 'cat /dev/null > {}' \;

echo "Log rotation complete"
