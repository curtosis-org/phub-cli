#!/usr/bin/env bash
set -e

echo "▶ Removing phub-cli..."

sudo rm -f /usr/local/bin/phub-cli
sudo rm -rf /usr/local/share/phub-cli

echo "✅ phub-cli uninstalled"
