#!/usr/bin/env bash

# Paths used in the Termux installation
BIN_FILE="$PREFIX/bin/phub-cli"
SHARE_DIR="$PREFIX/share/phub-cli"
TMP_DIR="$PREFIX/tmp"

echo "▶ Uninstalling phub-cli..."

# 1. Remove the binary
if [ -f "$BIN_FILE" ]; then
    rm "$BIN_FILE"
    echo "  [✓] Removed binary: $BIN_FILE"
else
    echo "  [!] Binary not found, skipping."
fi

# 2. Remove the shared modules and data
if [ -d "$SHARE_DIR" ]; then
    rm -rf "$SHARE_DIR"
    echo "  [✓] Removed share directory: $SHARE_DIR"
else
    echo "  [!] Share directory not found, skipping."
fi

# 3. Clean up the specific temp files
# We don't delete the whole $TMP_DIR because other apps might use it,
# we only delete phub-specific leftovers.
if [ -d "$TMP_DIR" ]; then
    rm -f "$TMP_DIR/phub_stream."*
    echo "  [✓] Cleaned up temporary stream files."
fi

echo -e "\n✅ phub-cli has been uninstalled."
echo "💡 Note: System packages (fzf, yt-dlp, etc.) were not removed."
