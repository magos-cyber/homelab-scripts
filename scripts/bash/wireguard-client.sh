#!/bin/bash
# WireGuard Client Management
# Generate client configs for WireGuard VPN

set -euo pipefail

WG_DIR="/etc/wireguard"
CLIENTS_DIR="$WG_DIR/clients"
SERVER_PUBKEY="${WG_DIR}/publickey"

mkdir -p "$CLIENTS_DIR"

CLIENT_NAME="${1:?Usage: $0 <client-name> [client-ip]}"
CLIENT_IP="${2:-}"

if [ -z "$CLIENT_IP" ]; then
    # Find next available IP
    LAST_IP=$(ls "$CLIENTS_DIR" 2>/dev/null | grep -oP '\K[0-9]+(?=\.conf$)' | sort -n | tail -1)
    CLIENT_IP="10.0.0.$(( ${LAST_IP:-100} + 1 ))"
fi

CLIENT_PRIVKEY="${CLIENTS_DIR}/${CLIENT_NAME}.key"
CLIENT_PUBKEY="${CLIENTS_DIR}/${CLIENT_NAME}.pub"
CLIENT_CONF="${CLIENTS_DIR}/${CLIENT_NAME}.conf"

# Generate keys
wg genkey | tee "$CLIENT_PRIVKEY" | wg pubkey > "$CLIENT_PUBKEY"

SERVER_ENDPOINT="${WG_SERVER_ENDPOINT:-vpn.example.com}"
SERVER_PUBKEY_CONTENT=$(cat "$SERVER_PUBKEY" 2>/dev/null || echo "SERVER_PUBLIC_KEY")

# Create client config
cat > "$CLIENT_CONF" <<EOF
[Interface]
Address = ${CLIENT_IP}/24
PrivateKey = $(cat "$CLIENT_PRIVKEY")
DNS = 10.0.0.1

[Peer]
PublicKey = ${SERVER_PUBKEY_CONTENT}
Endpoint = ${SERVER_ENDPOINT}:51820
AllowedIPs = 10.0.0.0/24, 192.168.1.0/24
PersistentKeepalive = 25
EOF

chmod 600 "$CLIENT_CONF"

echo "Client config created: $CLIENT_CONF"
echo "Client IP: $CLIENT_IP"
echo ""
echo "QR Code (for mobile):"
qrencode -t ansiutf8 < "$CLIENT_CONF"
