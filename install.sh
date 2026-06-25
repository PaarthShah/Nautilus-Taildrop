#!/usr/bin/env bash
set -e

echo "Installing Taildrop integration..."

# Check dependencies
if ! command -v tailscale &> /dev/null; then
    echo "Error: Tailscale is not installed. Please install it first: https://tailscale.com/download"
    exit 1
fi

if ! python3 -c "import gi" &> /dev/null; then
    echo "Error: python3-gi (PyGObject) is not installed. The GTK sender UI requires PyGObject."
    echo "  Fedora/RHEL: sudo dnf install python3-gobject"
    echo "  Ubuntu/Debian: sudo apt install python3-gi gir1.2-gtk-4.0 gir1.2-adw-1"
    exit 1
fi

# Create required directories
mkdir -p ~/.local/bin
mkdir -p ~/.config/systemd/user
mkdir -p ~/.local/share/nautilus/scripts

# Copy and set permissions
cp taildrop-auto-receive.sh ~/.local/bin/
chmod +x ~/.local/bin/taildrop-auto-receive.sh

cp taildrop-auto-receive.service ~/.config/systemd/user/

cp send-via-taildrop.py ~/.local/share/nautilus/scripts/"Send via Taildrop"
chmod +x ~/.local/share/nautilus/scripts/"Send via Taildrop"

# Enable and start the systemd user service
systemctl --user daemon-reload
systemctl --user enable --now taildrop-auto-receive.service

# Restart Nautilus so the Scripts menu is available from the file manager
nautilus -q 2>/dev/null || true

echo ""
echo "Installation complete!"
echo "The 'Scripts → Send via Taildrop' entry is now available in the file manager's Scripts menu."
echo "Files sent to this device will appear in ~/Downloads with a desktop notification."
