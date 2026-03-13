#!/usr/bin/env bash

get_categories() {
    local response

    if ! response=$(curl -fsSL "https://www.pornhub.com/webmasters/categories"); then
        echo "Failed to fetch categories from the API." >&2
        return 1
    fi

    if ! printf '%s' "$response" | jq -e '.categories | type == "array"' >/dev/null 2>&1; then
        echo "Unexpected categories API response (not valid JSON category data)." >&2
        return 1
    fi

    printf '%s' "$response" |
        jq -r '.categories[] | "\(.id)|\(.category)"' |
        sed 's/-/ /g; s/\b\(.\)/\u\1/g' |
        sort -t'|' -k2
}
