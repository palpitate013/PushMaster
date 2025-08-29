#!/usr/bin/env bash
# PushMaster Install Script

set -e

# CONFIGURATION
INSTALL_DIR="/usr/local/bin"
SERVICE_FILE="/etc/systemd/system/pushmaster.service"
PYTHON_SCRIPT="$INSTALL_DIR/pushmaster.py"
MONITOR_FOLDER="${1:-/path/to/repos}"  # User can pass folder as first argument

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "Please run as root (sudo)." 
   exit 1
fi

# Ensure dependencies
if ! command -v python3 &>/dev/null; then
    echo "Python3 not found, installing..."
    apt-get update && apt-get install -y python3 || true
fi

if ! command -v ntfy &>/dev/null; then
    echo "ntfy not found, installing..."
    pip3 install ntfy || true
fi

# Copy pushmaster.py (assumes it's in current directory)
if [[ ! -f "pushmaster.py" ]]; then
    echo "pushmaster.py not found in current directory."
    exit 1
fi
cp pushmaster.py "$PYTHON_SCRIPT"
chmod +x "$PYTHON_SCRIPT"

# Create systemd service
cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=PushMaster Git Monitor
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/env python3 $PYTHON_SCRIPT
Restart=always
User=$(whoami)
Environment=MONITOR_FOLDER=$MONITOR_FOLDER

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and enable service
systemctl daemon-reload
systemctl enable pushmaster.service
systemctl start pushmaster.service

echo "PushMaster installed successfully!"
echo "Monitoring folder: $MONITOR_FOLDER"
echo "Use 'sudo systemctl status pushmaster' to check status."
