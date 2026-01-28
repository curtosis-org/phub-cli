#!/usr/bin/env bash

#colors
RED='\033[0;31m'
BOLD_RED='\033[1;31m'
PINK='\033[38;5;206m'
HOT_PINK='\033[38;5;200m'
PURPLE='\033[0;35m'
BOLD_PURPLE='\033[1;35m'
MAGENTA='\033[0;95m'
DEEP_PINK='\033[38;5;125m'
ROSE='\033[38;5;197m'
GOLD='\033[38;5;220m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
BLINK='\033[5m'
NC='\033[0m'

PHUBCLI_BLINK=${PHUBCLI_BLINK:-0}

_ui_cols() {
    local cols
    cols=$(tput cols 2>/dev/null)
    if [[ -z "$cols" || ! "$cols" =~ ^[0-9]+$ ]]; then
        cols=80
    fi
    printf '%s' "$cols"
}

_ui_indent() {
    local content_w="$1"
    local cols
    cols=$(_ui_cols)
    local pad=$(( (cols - content_w) / 2 ))
    [ "$pad" -lt 0 ] && pad=0
    printf '%*s' "$pad" ''
}

_ui_hr() {
    local n="$1"
    printf '─%.0s' $(seq 1 "$n")
}

_ui_box_top() {
    local w="$1"
    local indent
    indent=$(_ui_indent $((w + 2)))
    printf '%b\n' "${indent}${BOLD_RED}┌$(_ui_hr "$w")┐${NC}"
}

_ui_box_bottom() {
    local w="$1"
    local indent
    indent=$(_ui_indent $((w + 2)))
    printf '%b\n' "${indent}${BOLD_RED}└$(_ui_hr "$w")┘${NC}"
}

_ui_box_title() {
    local w="$1"
    local title="$2"
    local indent
    indent=$(_ui_indent $((w + 2)))
    local padl=$(( (w - ${#title}) / 2 ))
    [ "$padl" -lt 0 ] && padl=0
    local padr=$(( w - padl - ${#title} ))
    [ "$padr" -lt 0 ] && padr=0
    printf '%b\n' "${indent}${BOLD_RED}│${NC}$(printf '%*s' "$padl" '')${HOT_PINK}${BOLD}${title}${NC}$(printf '%*s' "$padr" '')${BOLD_RED}│${NC}"
}

_ui_box_line_plain() {
    local w="$1"
    local plain="$2"
    local indent
    indent=$(_ui_indent $((w + 2)))
    local pad=$(( w - ${#plain} ))
    [ "$pad" -lt 0 ] && pad=0
    printf '%b\n' "${indent}${BOLD_RED}│${NC}${plain}$(printf '%*s' "$pad" '')${BOLD_RED}│${NC}"
}

_ui_menu_line() {
    local w="$1"
    local key="$2"
    local label="$3"
    local indent
    indent=$(_ui_indent $((w + 2)))
    local plain=" ${key} ${label}"
    local pad=$(( w - ${#plain} ))
    [ "$pad" -lt 0 ] && pad=0
    printf '%b\n' "${indent}${BOLD_RED}│${NC} ${HOT_PINK}${key}${NC} ${PINK}${label}${NC}$(printf '%*s' "$pad" '')${BOLD_RED}│${NC}"
}

show_home() {
    local title_fx=""
    if [ "${PHUBCLI_BLINK}" = "1" ]; then
        title_fx="${BLINK}"
    fi

    local inner_w=46
    local indent_logo
    local indent_text
    local logo_w
    logo_w=62
    indent_logo=$(_ui_indent "$logo_w")
    indent_text=$(_ui_indent 34)

    printf '%b\n' "${indent_logo}${BOLD_RED}   ██████╗ ██╗  ██╗██╗   ██╗██████╗        ██████╗ ██╗     ██╗${NC}"
    printf '%b\n' "${indent_logo}${HOT_PINK}   ██╔══██╗██║  ██║██║   ██║██╔══██╗      ██╔════╝ ██║     ██║${NC}"
    printf '%b\n' "${indent_logo}${DEEP_PINK}   ██████╔╝███████║██║   ██║██████╔╝      ██║      ██║     ██║${NC}"
    printf '%b\n' "${indent_logo}${PINK}   ██╔═══╝ ██╔══██║██║   ██║██╔══██╗      ██║      ██║     ██║${NC}"
    printf '%b\n' "${indent_logo}${ROSE}   ██║     ██║  ██║╚██████╔╝██████╔╝      ╚██████╔╝███████╗██║${NC}"
    printf '%b\n' "${indent_logo}${MAGENTA}   ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═════╝        ╚═════╝ ╚══════╝╚═╝${NC}"
    printf '\n'
    printf '%b\n' "${indent_text}${HOT_PINK}          ${BOLD}${title_fx}phub-cli${NC}"
    printf '%b\n' "${indent_text}${DEEP_PINK}    ${UNDERLINE}terminal video browser${NC}"
    printf '%b\n' "${indent_text}${PINK}  lust-driven streaming experience${NC}"
    printf '\n'
    printf '%b\n' "${indent_text}${GOLD}                v0.3.0${NC}"
    printf '\n'

    _ui_box_top "$inner_w"
    _ui_menu_line "$inner_w" "[1]" "Browse categories"
    _ui_menu_line "$inner_w" "[2]" "Search videos"
    _ui_menu_line "$inner_w" "[q]" "Quit"
    _ui_box_bottom "$inner_w"
    printf '\n'

    printf '%b\n' "${indent_text}${DEEP_PINK}Tip:${NC} ${PINK}Use arrow keys + Enter. Esc cancels fzf.${NC}"
}

pre_play_menu() {
    local w=38
    printf '\n' > /dev/tty
    _ui_box_top "$w" > /dev/tty
    _ui_box_title "$w" "Choose an action" > /dev/tty
    _ui_menu_line "$w" "[1]" "Watch" > /dev/tty
    _ui_menu_line "$w" "[2]" "Download" > /dev/tty
    _ui_menu_line "$w" "[3]" "Open in browser" > /dev/tty
    _ui_menu_line "$w" "[b]" "Back" > /dev/tty
    _ui_box_bottom "$w" > /dev/tty
    printf '\n' > /dev/tty

    read -r -p "$(printf '%b' "${HOT_PINK}Select option ❯ ${NC}")" choice < /dev/tty
    echo "$choice"
}

quality_menu() {
    local w=38
    printf '\n' > /dev/tty
    _ui_box_top "$w" > /dev/tty
    _ui_box_title "$w" "Select quality" > /dev/tty
    _ui_menu_line "$w" "[1]" "Best (1080p+)" > /dev/tty
    _ui_menu_line "$w" "[2]" "720p" > /dev/tty
    _ui_menu_line "$w" "[3]" "480p" > /dev/tty
    _ui_menu_line "$w" "[4]" "360p" > /dev/tty
    _ui_menu_line "$w" "[b]" "Back" > /dev/tty
    _ui_box_bottom "$w" > /dev/tty
    printf '\n' > /dev/tty

    read -r -p "$(printf '%b' "${HOT_PINK}Select quality ❯ ${NC}")" choice < /dev/tty
    echo "$choice"
}

post_play_menu() {
    local w=38
    printf '\n' > /dev/tty
    _ui_box_top "$w" > /dev/tty
    _ui_box_title "$w" "What next?" > /dev/tty
    _ui_menu_line "$w" "[1]" "Replay" > /dev/tty
    _ui_menu_line "$w" "[2]" "Back to results" > /dev/tty
    _ui_menu_line "$w" "[3]" "Back to home" > /dev/tty
    _ui_menu_line "$w" "[q]" "Quit" > /dev/tty
    _ui_box_bottom "$w" > /dev/tty
    printf '\n' > /dev/tty

    read -r -p "$(printf '%b' "${HOT_PINK}Select option ❯ ${NC}")" choice < /dev/tty
    echo "$choice"
}

post_download_menu() {
    local w=38
    printf '\n' > /dev/tty
    _ui_box_top "$w" > /dev/tty
    _ui_box_title "$w" "Download complete" > /dev/tty
    _ui_menu_line "$w" "[1]" "Another quality" > /dev/tty
    _ui_menu_line "$w" "[2]" "Back to results" > /dev/tty
    _ui_menu_line "$w" "[3]" "Back to home" > /dev/tty
    _ui_menu_line "$w" "[q]" "Quit" > /dev/tty
    _ui_box_bottom "$w" > /dev/tty
    printf '\n' > /dev/tty

    read -r -p "$(printf '%b' "${HOT_PINK}Select option ❯ ${NC}")" choice < /dev/tty
    echo "$choice"
}
