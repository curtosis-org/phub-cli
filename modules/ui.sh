#!/usr/bin/env bash

show_home() {
cat << "EOF"

   ██████╗ ██╗  ██╗██╗   ██╗██████╗        ██████╗ ██╗     ██╗
   ██╔══██╗██║  ██║██║   ██║██╔══██╗      ██╔════╝ ██║     ██║
   ██████╔╝███████║██║   ██║██████╔╝      ██║      ██║     ██║
   ██╔═══╝ ██╔══██║██║   ██║██╔══██╗      ██║      ██║     ██║
   ██║     ██║  ██║╚██████╔╝██████╔╝      ╚██████╔╝███████╗██║
   ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═════╝        ╚═════╝ ╚══════╝╚═╝

              terminal video browser
          lust-driven streaming experience

                   version v0.1.1

 ──────────────────────────────────────────────
    [1]  Browse categories
    [2]  Search videos
    [q]  Quit
 ──────────────────────────────────────────────

EOF
}




pre_play_menu() {
    echo "" > /dev/tty
    echo " What do you want to do? 🎬" > /dev/tty
    echo " ---------------------------------" > /dev/tty
    echo "  [1] Watch video" > /dev/tty
    echo "  [2] Download video" > /dev/tty
    echo "  [3] Open in browser" > /dev/tty
    echo "  [b] Back to results" > /dev/tty
    echo " ---------------------------------" > /dev/tty
    echo "" > /dev/tty

    read -r -p "Select option: " choice < /dev/tty
    echo "$choice"
}

quality_menu() {
    echo "" > /dev/tty
    echo " Select quality 📺" > /dev/tty
    echo " ---------------------------------" > /dev/tty
    echo "  [1] Best quality (1080p+)" > /dev/tty
    echo "  [2] 720p" > /dev/tty
    echo "  [3] 480p" > /dev/tty
    echo "  [4] 360p" > /dev/tty
    echo "  [b] Back" > /dev/tty
    echo " ---------------------------------" > /dev/tty
    echo "" > /dev/tty

    read -r -p "Select quality: " choice < /dev/tty
    echo "$choice"
}

post_play_menu() {
    echo "" > /dev/tty
    echo " What next? 💦" > /dev/tty
    echo " ---------------------------------" > /dev/tty
    echo "  [1] Replay video" > /dev/tty
    echo "  [2] Back to results" > /dev/tty
    echo "  [3] Back to home" > /dev/tty
    echo "  [q] Quit" > /dev/tty
    echo " ---------------------------------" > /dev/tty
    echo "" > /dev/tty

    read -r -p "Select option: " choice < /dev/tty
    echo "$choice"
}

post_download_menu() {
    echo "" > /dev/tty
    echo " Download complete! 💾" > /dev/tty
    echo " ---------------------------------" > /dev/tty
    echo "  [1] Download another quality" > /dev/tty
    echo "  [2] Back to results" > /dev/tty
    echo "  [3] Back to home" > /dev/tty
    echo "  [q] Quit" > /dev/tty
    echo " ---------------------------------" > /dev/tty
    echo "" > /dev/tty

    read -r -p "Select option: " choice < /dev/tty
    echo "$choice"
}

