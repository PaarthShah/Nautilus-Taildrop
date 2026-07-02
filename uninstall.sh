#!/usr/bin/env bash
set -e

echo "Uninstalling Taildrop integration..."

# Stop and disable the systemd service
systemctl --user stop taildrop-auto-receive.service 2>/dev/null || true
systemctl --user disable taildrop-auto-receive.service 2>/dev/null || true

# Remove installed files
rm -f ~/.local/bin/taildrop-auto-receive.sh
rm -f ~/.local/bin/send-via-taildrop
rm -f ~/.config/systemd/user/taildrop-auto-receive.service
rm -f ~/.local/share/nautilus-python/extensions/nautilus-taildrop.py
# Legacy Scripts-based install (pre-extension), removed for good measure
rm -f ~/.local/share/nautilus/scripts/"Send via Taildrop"

systemctl --user daemon-reload

# Restart Nautilus
nautilus -q 2>/dev/null || true

echo "Uninstall complete."
