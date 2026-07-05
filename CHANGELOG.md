# Changelog

All notable changes to this project will be documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

No unreleased changes yet.

## [1.0.0] - 2026-06-06

### Added

- Initial repository structure
- Windows Terminal settings with `Mattk Gruvbox Kitty` color scheme
- PowerShell 7 profile with Starship and Fastfetch
- Starship prompt config for Windows (powerline, OS icon, git status)
- Fastfetch config for Windows
- WSL Ubuntu 26.04 Zsh config (`.zshrc`)
- WSL Starship config (powerline, OS icon, git status, Node.js, Python)
- WSL Fastfetch config
- `scripts/deploy-windows.sh` — copies Windows configs to live locations
- `scripts/link-ubuntu.sh` — creates symlinks for WSL configs
- `.gitignore` for backup, temp, secret and editor files
