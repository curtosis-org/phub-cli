#!/usr/bin/env bash

get_categories() {
    curl -s "https://www.pornhub.com/webmasters/categories" |
        jq -r '.categories[] | "\(.id)|\(.category)"' |
        sed 's/-/ /g; s/\b\(.\)/\u\1/g' |
        sort -t'|' -k2
}
