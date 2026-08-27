#!/usr/bin/env python3
"""Crontab management utility."""
import subprocess, sys

def list_cron():
    result = subprocess.run(["crontab", "-l"], capture_output=True, text=True)
    print(result.stdout if result.returncode == 0 else "No crontab")

def add_cron(job):
    result = subprocess.run(["crontab", "-l"], capture_output=True, text=True)
    current = result.stdout if result.returncode == 0 else ""
    if job in current:
        print("Job already exists")
        return
    new_cron = current.strip() + "\n" + job + "\n"
    proc = subprocess.Popen(["crontab", "-"], stdin=subprocess.PIPE, text=True)
    proc.communicate(input=new_cron)
    print(f"Added: {job}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python cron-manager.py <list|add> [args]")
        sys.exit(1)
    cmd = sys.argv[1]
    if cmd == "list":
        list_cron()
    elif cmd == "add":
        add_cron(sys.argv[2])
