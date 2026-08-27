#!/bin/bash
# DNS Configuration
DNS_SERVERS="${@:-1.1.1.1 8.8.8.8 9.9.9.9}"
echo "=== DNS Configuration ==="
echo "Current DNS:"
cat /etc/resolv.conf | grep nameserver
for dns in $DNS_SERVERS; do
    if nslookup google.com "$dns" >/dev/null 2>&1; then
        echo "[OK] $dns"
    else
        echo "[FAIL] $dns"
    fi
done
