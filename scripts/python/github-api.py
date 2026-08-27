#!/usr/bin/env python3
"""GitHub API helper for repo management."""
import os
import json
import urllib.request

def get_repos(username, token=None):
    """Fetch all repos for a user."""
    req = urllib.request.Request(
        f"https://api.github.com/user/repos?per_page=100",
        headers={"Authorization": f"Bearer {token}"} if token else {}
    )
    with urllib.request.urlopen(req) as resp:
        return json.loads(resp.read().decode())

def create_issue(repo, title, body, token):
    """Create an issue in a repo."""
    url = f"https://api.github.com/repos/{repo}/issues"
    data = json.dumps({"title": title, "body": body}).encode()
    req = urllib.request.Request(url, data=data, headers={
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }, method="POST")
    with urllib.request.urlopen(req) as resp:
        return json.loads(resp.read().decode())

if __name__ == "__main__":
    repos = get_repos("magos-cyber")
    print(f"Found {len(repos)} repos")
    for r in repos:
        print(f"  {r['name']}: {r.get('description', 'No description')}")
