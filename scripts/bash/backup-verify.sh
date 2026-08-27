#!/bin/bash
# Verify backup integrity
# Checks backup files for corruption

BACKUP_DIR="${1:-/var/backups}"

echo "=== Backup Verification ==="
echo "Directory: $BACKUP_DIR"

find "$BACKUP_DIR" -name "*.tar.gz" -type f | while read backup; do
    if tar -tzf "$backup" >/dev/null 2>&1; then
        echo "[OK] $(basename "$backup")"
    else
        echo "[CORRUPT] $(basename "$backup")"
    fi
done

echo "Verification complete"
