#!/usr/bin/env python3
import os
import subprocess
import time
from pathlib import Path

# ===== CONFIGURATION =====
MONITOR_FOLDER = Path("/path/to/repos")  # Change to your folder
CHECK_INTERVAL = 3600                    # Seconds between checks (1 hour)
NTFY_TOPIC = "pushmaster"                # ntfy topic
# =========================

def notify(message: str):
    """Send an ntfy notification."""
    subprocess.run(["ntfy", "send", "-t", "PushMaster", "-b", message])

def has_uncommitted_changes(repo: Path) -> bool:
    result = subprocess.run(["git", "status", "--porcelain"], cwd=repo, capture_output=True, text=True)
    return bool(result.stdout.strip())

def get_unpushed_commits(repo: Path) -> str:
    result = subprocess.run(["git", "log", "origin/HEAD..HEAD", "--oneline"], cwd=repo, capture_output=True, text=True)
    return result.stdout.strip()

def show_diff(repo: Path):
    subprocess.run(["git", "diff"], cwd=repo)

def commit_changes(repo: Path):
    show_diff(repo)
    commit_msg = input(f"Enter commit message for {repo} (leave empty to skip): ").strip()
    if commit_msg:
        subprocess.run(["git", "add", "-A"], cwd=repo)
        subprocess.run(["git", "commit", "-m", commit_msg], cwd=repo)
        print(f"Committed changes in {repo}")
    else:
        print(f"Skipped commit in {repo}")

def push_changes(repo: Path):
    unpushed = get_unpushed_commits(repo)
    if unpushed:
        notify(f"Unpushed commits detected in {repo}")
        print(f"Unpushed commits in {repo}:\n{unpushed}")
        decision = input("Push these commits? [y/N]: ").strip().lower()
        if decision == "y":
            subprocess.run(["git", "push"], cwd=repo)
            print(f"Pushed commits in {repo}")
        else:
            print(f"Skipped push in {repo}")

def process_repo(repo: Path):
    if has_uncommitted_changes(repo):
        notify(f"Uncommitted changes detected in {repo}")
        print(f"Uncommitted changes in {repo}")
        commit_changes(repo)
    push_changes(repo)

def main():
    print(f"Starting PushMaster for folder: {MONITOR_FOLDER}")
    while True:
        for repo in MONITOR_FOLDER.iterdir():
            if (repo / ".git").exists() and repo.is_dir():
                process_repo(repo)
        time.sleep(CHECK_INTERVAL)

if __name__ == "__main__":
    main()
