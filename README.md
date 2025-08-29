# PushMaster

PushMaster is a Git repository monitor that keeps track of multiple repos in a specified folder. It sends notifications for uncommitted changes or commits that haven't been pushed, prompts for action, and shows file diffs. Ideal for keeping your projects synced automatically.

## Features

- Monitors all Git repositories within a specified folder.
- Sends ntfy notifications every hour after detecting changes.
- Prompts for commit messages for uncommitted changes.
- Prompts to push or ignore for unpushed commits.
- Shows file diffs for easier review.
- Can run automatically on system boot.

## Installation

### Using the install script
```bash
curl -sSL https://example.com/pushmaster/install.sh | bash
```

# Manual Installation

1. Clone the repository:

```bash
git clone https://example.com/pushmaster.git
cd pushmaster
```
2. Make the main script executable:

```bash
chmod +x pushmaster.sh
```
3. Configure the folder to monitor in config.json or inside the script.

    Start the script:

```bash
./pushmaster.sh
```

# NixOS Declarative Setup

Add the following to your configuration.nix:

```nix
{
  services.pushmaster = {
    enable = true;
    folder = "/path/to/repos"; # Change this to your folder
    user = "your-username";
  };
}
```

Then run:

```bash
sudo nixos-rebuild switch
```

# Usage

PushMaster runs continuously. It will notify you through ntfy when changes are detected:

    If uncommitted changes exist, you'll be prompted for a commit message.

    If commits are not pushed, you'll be prompted whether to push or ignore.

    You can view file diffs before committing or pushing.

# Uninstallation
Using uninstall script

``` bash
curl -sSL https://example.com/pushmaster/uninstall.sh | bash
```

# Manual

    Stop the running script.

    Remove files and configuration.

    Remove systemd service if installed:

``` bash
sudo systemctl stop pushmaster
sudo systemctl disable pushmaster
sudo rm /etc/systemd/system/pushmaster.service
```

# Requirements

    Git

    Python 3 (if script uses Python)

    ntfy (pip install ntfy or system package)

    Bash, coreutils