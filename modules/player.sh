#!/usr/bin/env bash

play_video() {
    viewkey="$1"
    page_url="https://www.pornhub.com/view_video.php?viewkey=$viewkey"

    start_time=$(date +%s)

    # Resolve stream URL first (FAST)
    stream_url=$(yt-dlp \
        --cookies-from-browser=firefox \
        -f "best[protocol=m3u8]/best" \
        --get-url \
        "$page_url" 2>/dev/null | head -n 1)

    # Failed to resolve stream
    [ -z "$stream_url" ] && return 1

    # Play stream directly (no ytdl hook)
    mpv \
        --really-quiet \
        --no-ytdl \
        --profile=fast \
        --hwdec=auto \
        --cache=yes \
        --cache-secs=10 \
        "$stream_url"

    end_time=$(date +%s)
    duration=$((end_time - start_time))

    # If playback exits too fast, treat as failure
    [ "$duration" -lt 5 ] && return 1

    return 0
}

