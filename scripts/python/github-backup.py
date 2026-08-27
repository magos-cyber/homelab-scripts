#!/usr/bin/env python3
"""
GitHub Repository Backup
Backs up all GitHub repos to a local directory
"""

import os
import json
import subprocess
import argparse
from datetime import datetime
from pathlib import Path

def get_repos(username, token=None):
    """Fetch all repos for a user"""
    import urllib.request
    req = urllib.request.Request(
        f"https://api.github.com/user/repos?per_page=100&visibility=all",
        headers={"Authorization": f"Bearer {token}"} if token else {}
    )
    with urllib.request.urlopen(req) as resp:
        return json.loads(resp.read().decode())

def backup_repo(repo_url, backup_dir, repo_name):
    """Clone or pull a repo"""
    repo_path = Path(backup_dir) / repo_name
    
    if repo_path.exists():
        print(f"  Pulling {repo_name}...")
        subprocess.run(["git", "-C", str(repo_path), "pull"], capture_output=True)
    else:
        print(f"  Cloning {repo_name}...")
        subprocess.run(["git", "clone", "--mirror", repo_url, str(repo_path)], capture_output=True)

def main():
    parser = argparse.ArgumentParser(description="Backup GitHub repos")
    parser.add_argument("--dir", default="./github-backup", help="Backup directory")
    parser.add_argument("--token", default=os.getenv("GITHUB_TOKEN"), help="GitHub token")
    args = parser.parse_args()

    os.makedirs(args.dir, exist_ok=True)
    
    print(f"Backing up GitHub repos to {args.dir}")
    print(f"Date: {datetime.now().isoformat()}")
    print()
    
    repos = get_repos("magos-cyber", args.token)
    print(f"Found {len(repos)} repos")
    
    for repo in repos:
        backup_repo(repo["clone_url"], args.dir, repo["name"])
    
    print(f"
Backup complete: {len(repos)} repos")

if __name__ == "__main__":
    main()
