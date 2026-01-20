#!/usr/bin/env bash

# Termux Non-Root Installer for phub-cli
BIN_DIR="$PREFIX/bin"
SHARE_DIR="$PREFIX/share/phub-cli"
MODULES_DIR="$SHARE_DIR/modules"

echo "▶ Starting Unified Termux Install"

# 1. Install System Dependencies
echo "▶ Checking dependencies..."
pkg update
pkg install -y python mpv fzf jq curl ffmpeg termux-api

# 2. Install Python Dependencies
echo "▶ Installing Python modules..."
pkg install -y python-lxml
pip install -U yt-dlp beautifulsoup4

# 3. Create Project Structure
echo "▶ Creating directories..."
mkdir -p "$BIN_DIR"
mkdir -p "$MODULES_DIR"
mkdir -p "$PREFIX/tmp"

# 4. Copy Files
echo "▶ Copying files..."
cp phub-cli "$BIN_DIR/"
cp modules/* "$MODULES_DIR/"

# 5. Apply Termux Patches
echo "▶ Patching for Termux environment..."

# Fix Shebangs
termux-fix-shebang "$BIN_DIR/phub-cli"
termux-fix-shebang "$MODULES_DIR/"*

# Fix Internal Paths (DIR variable and /tmp)
sed -i "s|^DIR=.*|DIR=\"$SHARE_DIR\"|" "$BIN_DIR/phub-cli"
find "$SHARE_DIR" -type f -exec sed -i "s|/tmp/|$PREFIX/tmp/|g" {} +

# Patch Categories (User-Agent)
sed -i 's/curl -s/curl -s -A "Mozilla\/5.0"/' "$MODULES_DIR/categories.sh"

# Patch Player (Force mpv-android via 'am start')
# This assumes you have the mpv-android app installed.
sed -i 's/termux-open "$stream_url"/am start --user 0 -a android.intent.action.VIEW -d "$stream_url" -n is.xyz.mpv\/.MPVActivity > \/dev\/null 2>\&1/' "$MODULES_DIR/player.sh"
# Fallback if the script used a standard mpv call
sed -i '/mpv \\/,/ "$stream_url"/c\    am start --user 0 -a android.intent.action.VIEW -d "$stream_url" -n is.xyz.mpv/.MPVActivity > /dev/null 2>\&1' "$MODULES_DIR/player.sh"

# 6. Set Permissions
chmod +x "$BIN_DIR/phub-cli"
chmod +x "$MODULES_DIR/"*

echo -e "\n✅ Installation Complete!"
echo "▶ Make sure you have the 'mpv-android' app installed from Play Store/F-Droid."
echo "▶ Run it with: phub-cli"
