#!/usr/bin/env python3
"""Send notifications via Telegram bot."""
import os
import sys
import urllib.request
import urllib.parse

def send_message(message, token=None, chat_id=None):
    token = token or os.getenv("TELEGRAM_BOT_TOKEN")
    chat_id = chat_id or os.getenv("TELEGRAM_CHAT_ID")
    
    if not token or not chat_id:
        print("Error: Set TELEGRAM_BOT_TOKEN and TELEGRAM_CHAT_ID")
        return False
    
    url = f"https://api.telegram.org/bot{token}/sendMessage"
    data = urllib.parse.urlencode({"chat_id": chat_id, "text": message}).encode()
    
    try:
        req = urllib.request.Request(url, data=data, method="POST")
        with urllib.request.urlopen(req, timeout=10) as resp:
            return resp.status == 200
    except Exception as e:
        print(f"Error: {e}")
        return False

if __name__ == "__main__":
    msg = sys.argv[1] if len(sys.argv) > 1 else "Hello from homelab!"
    success = send_message(msg)
    print("Sent!" if success else "Failed!")
