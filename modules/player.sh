#!/usr/bin/env bash

#importing colors
DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$DIR/modules/ui.sh"

#spinner 
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'

    while kill -0 "$pid" 2>/dev/null; do
        for i in $(seq 0 3); do
            printf "\r   ${HOT_PINK}%s${NC} Fetching stream... " "${spinstr:$i:1}" > /dev/tty
            sleep "$delay"
        done
    done
    printf "\r" > /dev/tty
}

play_video() {
    viewkey="$1"
    page_url="https://www.pornhub.com/view_video.php?viewkey=$viewkey"

    start_time=$(date +%s)

    #pre play
    clear

    messages=(
        "🔥 Preparing your video..."
        "💋 Unwrapping forbidden packets..."
        "💭 Please wait, lust takes time..."
        "😈 Negotiating with the content gods..."
        "📡 Tapping into the pleasure servers..."
        "🧠 Calibrating dopamine receptors..."
        "🍑 Warming up the pixels..."
        "🔓 Bypassing moral firewalls..."
        "💦 Hydrating the stream pipeline..."
        "📦 Extracting premium sensations..."
        "🕯 Lighting candles in the data center..."
        "🎥 Aligning sinful frames..."
    )
    pick1=${messages[RANDOM % ${#messages[@]}]}
    pick2=${messages[RANDOM % ${#messages[@]}]}
    pick3=${messages[RANDOM % ${#messages[@]}]}

    echo "" > /dev/tty
    echo -e "  ${HOT_PINK}$pick1${NC}" > /dev/tty
    sleep 0.3
    echo -e "  ${PINK}$pick2${NC}" > /dev/tty
    sleep 0.3
    echo -e "  ${ROSE}$pick3${NC}" > /dev/tty
    echo "" > /dev/tty

    #final
    echo "" > /dev/tty
    echo -e "  ${GOLD}▶ Launching player...${NC}" > /dev/tty
    sleep 0.6

    #play — let mpv use yt-dlp directly (avoids token expiration)
    mpv \
        --really-quiet \
        --profile=fast \
        --hwdec=auto \
        --cache=yes \
        --cache-secs=10 \
        --ytdl-format="bestvideo[height<=1080]+bestaudio/best" \
        --ytdl-raw-options="cookies-from-browser=firefox" \
        "$page_url"

    end_time=$(date +%s)
    duration=$((end_time - start_time))

    #failure
    [ "$duration" -lt 5 ] && return 1

    return 0
}

download_spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'

    while kill -0 "$pid" 2>/dev/null; do
        for i in $(seq 0 3); do
            printf "\r   ${GOLD}%s${NC} Downloading... " "${spinstr:$i:1}" > /dev/tty
            sleep "$delay"
        done
    done
    printf "\r" > /dev/tty
}

download_video() {
    viewkey="$1"
    quality="$2"
    page_url="https://www.pornhub.com/view_video.php?viewkey=$viewkey"
    download_dir="$HOME/Videos/phub-cli"

    # Create download directory if it doesn't exist
    mkdir -p "$download_dir"

    # Set format based on quality selection
    case "$quality" in
        1)
            format="bestvideo+bestaudio/best"
            quality_name="best"
            ;;
        2)
            format="bestvideo[height<=720]+bestaudio/best[height<=720]"
            quality_name="720p"
            ;;
        3)
            format="bestvideo[height<=480]+bestaudio/best[height<=480]"
            quality_name="480p"
            ;;
        4)
            format="bestvideo[height<=360]+bestaudio/best[height<=360]"
            quality_name="360p"
            ;;
        *)
            format="bestvideo+bestaudio/best"
            quality_name="best"
            ;;
    esac

    clear

    messages=(
        "📥 Initiating download sequence..."
        "💾 Preparing storage containers..."
        "🔒 Securing the goods..."
        "📦 Packaging premium content..."
        "🚀 Launching download protocol..."
        "💿 Writing to disk with passion..."
    )
    pick1=${messages[RANDOM % ${#messages[@]}]}
    pick2=${messages[RANDOM % ${#messages[@]}]}

    echo "" > /dev/tty
    echo -e "  ${HOT_PINK}$pick1${NC}" > /dev/tty
    sleep 0.3
    echo -e "  ${PINK}$pick2${NC}" > /dev/tty
    echo "" > /dev/tty
    echo -e "  ${GOLD}📺 Quality: $quality_name${NC}" > /dev/tty
    echo -e "  ${DEEP_PINK}📁 Destination: $download_dir${NC}" > /dev/tty
    echo "" > /dev/tty

    # Download with yt-dlp
    yt-dlp \
        --cookies-from-browser=firefox \
        -f "$format" \
        -o "$download_dir/%(title)s.%(ext)s" \
        --no-playlist \
        --progress \
        "$page_url" 2>&1 | tee /tmp/phub_download.$$ > /dev/tty

    download_status=${PIPESTATUS[0]}

    if [ "$download_status" -eq 0 ]; then
        echo "" > /dev/tty
        echo -e "  ${GOLD}✅ Download complete!${NC}" > /dev/tty
        echo -e "  ${DEEP_PINK}📁 Saved to: $download_dir${NC}" > /dev/tty
        sleep 1
        return 0
    else
        echo "" > /dev/tty
        echo -e "  ${RED}❌ Download failed.${NC}" > /dev/tty
        echo -e "  ${ROSE}😞 Video might be unavailable or restricted.${NC}" > /dev/tty
        sleep 2
        return 1
    fi

    rm -f /tmp/phub_download.$$
}

open_in_browser() {
    viewkey="$1"
    page_url="https://www.pornhub.com/view_video.php?viewkey=$viewkey"

    echo "" > /dev/tty
    echo -e "  ${HOT_PINK}🌐 Opening in browser...${NC}" > /dev/tty

    if command -v xdg-open >/dev/null; then
        xdg-open "$page_url" 2>/dev/null &
    elif command -v open >/dev/null; then
        open "$page_url" 2>/dev/null &
    else
        echo -e "  ${RED}❌ No browser opener found${NC}" > /dev/tty
        sleep 2
        return 1
    fi

    sleep 1
    return 0
}
