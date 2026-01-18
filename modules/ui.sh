#!/usr/bin/env bash

show_home() {
cat << "EOF"
                	       █▀█ █░█ █░█ █▄▄     █▀▀ █░░ █      
                	       █▀▀ █▀█ █▄█ █▄█     █▄▄ █▄▄ █

                   ██▀▄▀█ ▄▀█ █▀▄ █▀▀   █░█░█ █ ▀█▀ █░█   █░░ █░█ █▀ ▀█▀
                    █░▀░█ █▀█ █▄▀ ██▄   ▀▄▀▄▀ █ ░█░ █▀█   █▄▄ █▄█ ▄█ ░█░       
				---------------------------------
				  [1] Browse categories
				  [2] Search videos
				  [q] Quit
	               	        ---------------------------------

EOF
}



post_play_menu() {
    echo
    echo " What next?"
    echo " ---------------------------------"
    echo "  [1] Replay video"
    echo "  [2] Back to results"
    echo "  [3] Back to home"
    echo "  [q] Quit"
    echo " ---------------------------------"
    echo
    read -r -p "Select option: " choice </dev/tty
    echo "$choice"
}
