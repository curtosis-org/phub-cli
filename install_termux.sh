#!/usr/bin/env bash

# Termux Non-Root Installer for phub-cli
BIN_DIR="$PREFIX/bin"
SHARE_DIR="$PREFIX/share/phub-cli"
MODULES_DIR="$SHARE_DIR/modules"

echo "▶ Starting Unified Termux Install with Stream Fix..."

# 1. Install System Dependencies
pkg update
pkg install -y python mpv fzf jq curl ffmpeg termux-api

# 2. Install Python Dependencies
pkg install -y python-lxml
pip install -U yt-dlp beautifulsoup4

# 3. Create Project Structure
mkdir -p "$BIN_DIR" "$MODULES_DIR" "$PREFIX/tmp"

# 4. Copy Files from project folder to system
cp phub-cli "$BIN_DIR/"
cp modules/* "$MODULES_DIR/"

# 5. Apply Termux Patches
echo "▶ Patching for Termux environment..."

# Fix Shebangs
termux-fix-shebang "$BIN_DIR/phub-cli"
termux-fix-shebang "$MODULES_DIR/"*

# Fix Internal Paths
sed -i "s|^DIR=.*|DIR=\"$SHARE_DIR\"|" "$BIN_DIR/phub-cli"
find "$SHARE_DIR" -type f -exec sed -i "s|/tmp/|$PREFIX/tmp/|g" {} +

# --- THE STREAM FETCH FIX ---
echo "▶ Patching player.sh to fix stream extraction..."
# This block locates the yt-dlp call in player.sh and replaces the entire command
# including removing the firefox cookie flag and adding the User-Agent.
cat << 'EOF' > "$MODULES_DIR/player.sh.new"
#!/usr/bin/env bash

TEMP_FILE="$PREFIX/tmp/phub_stream.$$"

spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while kill -0 "$pid" 2>/dev/null; do
        for i in $(seq 0 3); do
            printf "\r    %s Fetching stream... " "${spinstr:$i:1}" > /dev/tty
            sleep "$delay"
        done
    done
    printf "\r" > /dev/tty
}

play_video() {
    viewkey="$1"
    page_url="https://www.pornhub.com/view_video.php?viewkey=$viewkey"
    start_time=$(date +%s)
    clear
    echo -e "\n  🔥 Preparing your video stream..." > /dev/tty

    (
        yt-dlp \
            --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" \
            -f "best[protocol=m3u8]/best" \
            --get-url \
            "$page_url" 2>/dev/null | head -n 1
    ) > "$TEMP_FILE" &

    ytdlp_pid=$!
    spinner "$ytdlp_pid"
    wait "$ytdlp_pid"
    stream_url=$(cat "$TEMP_FILE")
    rm -f "$TEMP_FILE"

    if [ -z "$stream_url" ]; then
        echo -e "\n  ❌ Failed to fetch stream." > /dev/tty
        return 1
    fi

    echo -e "\n  ▶ Launching MPV Android..." > /dev/tty
    am start --user 0 -a android.intent.action.VIEW -d "$stream_url" -n is.xyz.mpv/.MPVActivity > /dev/null 2>&1
    return 0
}
EOF
mv "$MODULES_DIR/player.sh.new" "$MODULES_DIR/player.sh"

# 6. Set Permissions
chmod +x "$BIN_DIR/phub-cli"
chmod +x "$MODULES_DIR/"*

echo -e "\n✅ Installation and Patching Complete!"
echo "▶ Run: phub-cli"
