#!/bin/bash
# User management utilities

set -euo pipefail

case "${1:-help}" in
    create)
        USERNAME="${2:?Usage: $0 create <username>}"
        useradd -m -s /bin/bash "$USERNAME"
        echo "User $USERNAME created"
        passwd "$USERNAME"
        ;;
    delete)
        USERNAME="${2:?Usage: $0 delete <username>}"
        userdel -r "$USERNAME" 2>/dev/null || true
        echo "User $USERNAME deleted"
        ;;
    sudo)
        USERNAME="${2:?Usage: $0 sudo <username>}"
        usermod -aG sudo "$USERNAME"
        echo "Added $USERNAME to sudo group"
        ;;
    list)
        echo "=== System Users ==="
        awk -F: '$3 >= 1000 && $3 < 65534 {print $1}' /etc/passwd
        ;;
    *)
        echo "Usage: $0 {create|delete|sudo|list}"
        ;;
esac
