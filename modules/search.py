#!/usr/bin/env python3

import sys
import re
import requests
from bs4 import BeautifulSoup

if len(sys.argv) < 2:
    sys.exit(1)

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

for block in soup.find_all("li", class_=re.compile(r"videoblock")):
    a = block.find("a", href=re.compile(r"viewkey="))
    if not a:
        continue

    href = a.get("href", "")
    title = a.get("title", "").strip()

    if not title:
        continue

    title_l = title.lower()

    if not any(k in title_l for k in keywords):
        continue

    match = re.search(r"viewkey=([a-zA-Z0-9]+)", href)
    if not match:
        continue

    viewkey = match.group(1)

    if viewkey in seen:
        continue

    seen.add(viewkey)

    img = block.find("img")
    thumbnail = ""
    if img:
        thumbnail = img.get("src") or img.get("data-src") or ""

    print(f"{viewkey}|{title}|{thumbnail}")
