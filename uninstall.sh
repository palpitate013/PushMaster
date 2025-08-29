#!/usr/bin/env bash
# PushMaster Uninstall Script

set -e

# CONFIGURATION
INSTALL_DIR="/usr/local/bin"
SERVICE_FILE="/etc/systemd/system/pushmaster.service"
PYTHON_SCRIPT="$INSTALL_DIR/pushmaster.py"

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "Please run as root (sudo)." 
   exit 1
fi

# Stop and disable the service
if systemctl list-units --full -all | grep -q "pushmaster.service"; then
    echo "Stopping PushMaster service..."
    systemctl stop pushmaster.service
    systemctl disable pushmaster.service
    systemctl daemon-reload
    echo "Service stopped and disabled."
else
    echo "PushMaster service not found."
fi

# Remove the Python script
if [[ -f "$PYTHON_SCRIPT" ]]; then
    rm -f "$PYTHON_SCRIPT"
    echo "Removed $PYTHON_SCRIPT"
else
    echo "Python script not found at $PYTHON_SCRIPT"
fi

# Remove systemd service file
if [[ -f "$SERVICE_FILE" ]]; then
    rm -f "$SERVICE_FILE"
    echo "Removed $SERVICE_FILE"
fi

echo "PushMaster uninstalled successfully!"
