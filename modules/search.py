#!/usr/bin/env python3

import sys
import re
import requests
from bs4 import BeautifulSoup

if len(sys.argv) < 2:
    sys.exit(1)

# Last arg is page number if it's a digit
if len(sys.argv) > 2 and sys.argv[-1].isdigit():
    page = int(sys.argv[-1])
    query = " ".join(sys.argv[1:-1])
else:
    page = 1
    query = " ".join(sys.argv[1:])

keywords = [k.lower() for k in query.split()]

url = "https://www.pornhub.com/video/search"
params = {"search": query, "page": page}

headers = {
    "User-Agent": "Mozilla/5.0"
}

html = requests.get(url, params=params, headers=headers, timeout=15).text
soup = BeautifulSoup(html, "html.parser")

seen = set()

for a in soup.find_all("a", href=re.compile(r"view_video\.php\?viewkey=")):
    href = a.get("href", "")
    title = a.get("title", "").strip()

    if not title:
        continue

    title_l = title.lower()

    # 🔥 FILTER: title must contain at least ONE keyword
    if not any(k in title_l for k in keywords):
        continue

    match = re.search(r"viewkey=([a-zA-Z0-9]+)", href)
    if not match:
        continue

    viewkey = match.group(1)

    if viewkey in seen:
        continue

    seen.add(viewkey)
    print(f"{viewkey}|{title}")
