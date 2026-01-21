#!/usr/bin/env bash

# Require root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (sudo ./install.sh)"
  exit 1
fi

PREFIX="/usr/local"
BIN="$PREFIX/bin"
SHARE="$PREFIX/share/phub-cli"

echo "▶ Installing phub-cli"

# --- Dependency check ---
deps=(bash mpv fzf yt-dlp python3)
for d in "${deps[@]}"; do
  if ! command -v "$d" >/dev/null; then
    echo "❌ Missing dependency: $d"
    exit 1
  fi
done

# --- Python dependency check (NON-FATAL MESSAGE) ---
if ! python3 - <<EOF >/dev/null 2>&1
import bs4
EOF
then
  echo "❌ Missing python dependency: beautifulsoup4"
  echo "   Arch: sudo pacman -S python-beautifulsoup4"
  echo "   Debian/Ubuntu: sudo apt install python3-bs4"
  exit 1
fi

if ! python3 - <<EOF >/dev/null 2>&1
import requests
EOF
then
  echo "❌ Missing python dependency: requests"
  echo "   Arch: sudo pacman -S python-requests"
  echo "   Debian/Ubuntu: sudo apt install python3-requests"
  exit 1
fi

# --- Install files ---
echo "▶ Creating directories"
mkdir -p "$BIN"
mkdir -p "$SHARE"

echo "▶ Copying modules"
rm -rf "$SHARE/modules"
cp -r modules "$SHARE/"

echo "▶ Installing binary"
cp phub-cli "$BIN/phub-cli"

echo "▶ Patching module path"
sed -i "s|^DIR=.*|DIR=\"$SHARE\"|" "$BIN/phub-cli"

echo "▶ Setting permissions"
chmod +x "$BIN/phub-cli"
chmod +x "$SHARE/modules/"*.sh
chmod +x "$SHARE/modules/"*.py

echo
echo "✅ phub-cli installed successfully"
echo "▶ Run it with: phub-cli"
