#!/usr/bin/env python3
"""
DNS Monitor
Monitor DNS resolution and alert on changes
"""

import socket
import json
import os
import hashlib
from datetime import datetime
from pathlib import Path

DNS_STATE_FILE = Path.home() / ".dns-monitor-state.json"

def resolve_dns(domain):
 """Resolve a domain to IPs"""
 try:
 ips = socket.getaddrinfo(domain, None, socket.AF_INET)
 return sorted(list(set(ip[4][0] for ip in ips)))
 except socket.gaierror as e:
 return [f"ERROR: {e}"]

def load_state():
 """Load previous DNS state"""
 if DNS_STATE_FILE.exists():
 return json.loads(DNS_STATE_FILE.read_text())
 return {}

def save_state(state):
 """Save current DNS state"""
 DNS_STATE_FILE.write_text(json.dumps(state, indent=2))

def main():
 domains = os.getenv("DNS_DOMAINS", "google.com,cloudflare.com").split(",")
 
 print(f"=== DNS Monitor ===")
 print(f"Date: {datetime.now().isoformat()}")
 print()
 
 state = load_state()
 changes = []
 
 for domain in domains:
 domain = domain.strip()
 current_ips = resolve_dns(domain)
 previous_ips = state.get(domain, [])
 
 if previous_ips and current_ips != previous_ips:
 changes.append({
 "domain": domain,
 "previous": previous_ips,
 "current": current_ips
 })
 print(f" {domain}: CHANGED")
 print(f" Previous: {previous_ips}")
 print(f" Current: {current_ips}")
 else:
 print(f" {domain}: {current_ips}")
 
 state[domain] = current_ips
 
 save_state(state)
 
 if changes:
 print(f"
 {len(changes)} DNS change(s) detected!")
 # Send alert if configured
 if os.getenv("TELEGRAM_BOT_TOKEN"):
 import urllib.request
 msg = "DNS Changes Detected:\n" + "\n".join(
 f"{c['domain']}: {c['previous']} → {c['current']}" for c in changes
 )
 urllib.request.urlopen(
 f"https://api.telegram.org/bot{os.getenv('TELEGRAM_BOT_TOKEN')}/sendMessage",
 data=f"chat_id={os.getenv('TELEGRAM_CHAT_ID')}&text={msg}".encode()
 )

if __name__ == "__main__":
 main()
