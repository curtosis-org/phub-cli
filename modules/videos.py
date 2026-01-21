#!/usr/bin/env python3

import sys
import re
import requests
from bs4 import BeautifulSoup

if len(sys.argv) < 2:
    sys.exit(1)

category_id = sys.argv[1]
page = int(sys.argv[2]) if len(sys.argv) > 2 else 1

url = f"https://www.pornhub.com/video?c={category_id}&page={page}"

headers = {
    "User-Agent": "Mozilla/5.0"
}

html = requests.get(url, headers=headers, timeout=15).text
soup = BeautifulSoup(html, "html.parser")

seen = set()

for a in soup.find_all("a", href=re.compile(r"view_video\.php\?viewkey=")):
    href = a.get("href", "")
    title = a.get("title", "").strip()

    if not title:
        continue

    match = re.search(r"viewkey=([a-zA-Z0-9]+)", href)
    if not match:
        continue

    viewkey = match.group(1)

    if viewkey in seen:
        continue

    seen.add(viewkey)
    print(f"{viewkey}|{title}")
