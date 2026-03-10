#!/usr/bin/env bash

PHUBCLI_REPO="https://github.com/curtosis-org/phub-cli.git"
PHUBCLI_API="https://api.github.com/repos/curtosis-org/phub-cli/commits/main"
PHUBCLI_VERSION_FILE="/usr/local/share/phub-cli/.version"

# Check for updates (non-blocking, silent)
# Sets PHUBCLI_UPDATE_AVAILABLE=1 if update found
check_for_update() {
    PHUBCLI_UPDATE_AVAILABLE=0

    # Get local version hash
    if [ ! -f "$PHUBCLI_VERSION_FILE" ]; then
        PHUBCLI_UPDATE_AVAILABLE=1
        return
    fi
    local local_hash
    local_hash=$(cat "$PHUBCLI_VERSION_FILE" 2>/dev/null)

    # Get remote hash from GitHub API
    local remote_hash
    remote_hash=$(curl -sf --max-time 4 \
        -H "Accept: application/vnd.github.sha" \
        "$PHUBCLI_API" 2>/dev/null)

    if [ -z "$remote_hash" ]; then
        return
    fi

    if [ "$local_hash" != "$remote_hash" ]; then
        PHUBCLI_UPDATE_AVAILABLE=1
    fi
}

# Perform the update
do_update() {
    local tmpdir
    tmpdir=$(mktemp -d)

    echo ""
    echo -e "  ${HOT_PINK}📥 Downloading latest version...${NC}"
    echo ""

    if ! git clone --depth 1 "$PHUBCLI_REPO" "$tmpdir" 2>/dev/null; then
        echo -e "  ${RED}❌ Failed to download update.${NC}"
        echo -e "  ${ROSE}Check your internet connection.${NC}"
        rm -rf "$tmpdir"
        sleep 2
        return 1
    fi

    echo -e "  ${GOLD}🔧 Installing update...${NC}"
    echo ""

    if ! sudo "$tmpdir/install.sh"; then
        echo -e "  ${RED}❌ Update failed during install.${NC}"
        rm -rf "$tmpdir"
        sleep 2
        return 1
    fi

    rm -rf "$tmpdir"

    echo ""
    echo -e "  ${GOLD}✅ Updated successfully!${NC}"
    echo -e "  ${PINK}Restart phub-cli to use the new version.${NC}"
    echo ""
    read -r -p "$(printf '%b' "${HOT_PINK}Press Enter to exit...${NC}")" _ </dev/tty
    exit 0
}
