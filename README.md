<p align="center">
<br>
<a href="http://makeapullrequest.com"><img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg"></a>
<img src="https://img.shields.io/badge/os-linux-brightgreen">
<img src="https://img.shields.io/badge/os-mac-yellowgreen">
<img src="https://img.shields.io/badge/interface-terminal-blue">
<img src="https://img.shields.io/badge/player-mpv-red">
<br>
</p>

<h1 align="center">
phub-cli
</h1>

<h3 align="center">
A terminal-based video browser inspired by ani-cli.<br>
Browse, search, and stream directly from <a href="https://www.pornhub.com/">pornhub.com</a> — no browser required.
</h3>

<p align="center">
<b>Made with lust.</b><br>
</p>

---

## Showcase

```bash
phub-cli
```

## Features

- Browse categories using fzf
- Search videos by keyword
- Paginated results for large categories and searches
- Instant streaming via mpv
- Direct stream extraction using yt-dlp
- Download videos in multiple qualities (1080p, 720p, 480p, 360p)
- Open videos directly in your default browser
- ani-cli–style navigation flow
- Graceful handling of broken or unavailable videos
- Clean terminal UI with interactive menus
- No browser required for playback
- No accounts, no tracking, no clutter


---



## Table of Contents


- [Installation](#installation)
- [Dependencies](#dependencies)
- [Usage](#usage)
- [Fixing errors](#fixing-errors)
- [Technical Notes](#technical-notes)
- [Disclaimer](#disclaimer)

## Installation

From source (recommended)

```bash
git clone https://github.com/curtosis-org/phub-cli.git
cd phub-cli
chmod +x install.sh
sudo ./install.sh
```

After installation, run from anywhere:

```bash
phub-cli
```

## Dependencies

phub-cli relies on external tools and system Python packages.
You must install these before running the installer.

# Required

- bash

- mpv

- fzf

- yt-dlp

- python3

- python3-bs4 (BeautifulSoup)

### Arch Linux

```bash
sudo pacman -S mpv fzf yt-dlp python python-beautifulsoup4
```

### Debian / Ubuntu

```bash
sudo apt install mpv fzf yt-dlp python3 python3-bs4
```

### Fedora

```bash
sudo dnf install mpv fzf yt-dlp python3 python3-beautifulsoup4
```
### macOS (Homebrew)

```bash
brew install mpv fzf yt-dlp python
pip3 install beautifulsoup4
```

## Usage

```bash
phub-cli
```
You will be presented with:

- Browse categories

- Search videos

- Quit

Navigation is entirely keyboard-driven using fzf.

## Fixing errors
If a video fails to play:

- It may be geo-blocked
- It may be removed
- It may require cookies/login

phub-cli will:
- detect fast failures 
- return you to the selection menu

allow retry or navigation without crashing

Ensure your dependencies are up to date:
```bash
yt-dlp -U
```

## Technical Notes

- Uses yt-dlp to resolve stream URLs before playback
- mpv is used only as a player, not as a scraper
- Input is explicitly read from /dev/tty to avoid fzf / mpv stdin conflicts
- No PhantomJS dependency
- No virtualenv required
- No downloads unless you modify the scripts yourself

## Supported Platforms

Tier 1 (tested)

- Linux (Arch, Debian, Fedora)
- macOS

Tier 2 (may work)

- WSL
- Termux (manual setup)

Windows, iOS, and consoles are not officially supported.

## Disclaimer
This project does not host, store, or distribute any media.
It only provides a terminal interface to publicly accessible content.

Use responsibly and in accordance with your local laws.








** Inspired by ani-cli. Built for terminals. Powered by curiosity and lust. **

