#!/usr/bin/env python3
"""
SSL Certificate Checker
Check SSL certificate expiration for multiple domains
"""

import ssl
import socket
import datetime
import argparse
import sys

def check_ssl(hostname, port=443, timeout=5):
    """Check SSL certificate for a hostname"""
    try:
        context = ssl.create_default_context()
        with socket.create_connection((hostname, port), timeout=timeout) as sock:
            with context.wrap_socket(sock, server_hostname=hostname) as ssock:
                cert = ssock.getpeercert()
                expires = datetime.datetime.strptime(cert["notAfter"], "%b %d %H:%M:%S %Y %Z")
                remaining = expires - datetime.datetime.now()
                return {
                    "hostname": hostname,
                    "expires": expires.isoformat(),
                    "days_left": remaining.days,
                    "issuer": dict(x[0] for x in cert["issuer"]),
                    "status": "ok" if remaining.days > 7 else "warning" if remaining.days > 0 else "expired"
                }
    except Exception as e:
        return {"hostname": hostname, "status": "error", "error": str(e)}

def main():
    parser = argparse.ArgumentParser(description="Check SSL certificates")
    parser.add_argument("domains", nargs="+", help="Domains to check")
    parser.add_argument("--warning-days", type=int, default=14, help="Warning threshold")
    args = parser.parse_args()

    print("=== SSL Certificate Check ===")
    print(f"Date: {datetime.datetime.now().isoformat()}")
    print()

    failed = 0
    for domain in args.domains:
        result = check_ssl(domain)
        status_icon = {"ok": "✓", "warning": "⚠", "expired": "✗", "error": "✗"}
        icon = status_icon.get(result["status"], "?")
        
        if result["status"] == "ok":
            print(f"{icon} {domain}: {result['days_left']} days left")
        elif result["status"] == "warning":
            print(f"{icon} {domain}: {result['days_left']} days left (WARNING)")
            failed += 1
        else:
            print(f"{icon} {domain}: {result.get('error', 'EXPIRED')}")
            failed += 1

    sys.exit(1 if failed else 0)

if __name__ == "__main__":
    main()
