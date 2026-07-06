# Windows Terminal

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Windows](https://img.shields.io/badge/Windows-0078D6?logo=windows&logoColor=fff)](https://www.microsoft.com/windows)
[![WSL2](https://img.shields.io/badge/WSL2-Ubuntu%2026.04-E95420?logo=ubuntu&logoColor=fff)](https://learn.microsoft.com/windows/wsl/)

Personal Windows terminal environment — Windows Terminal, PowerShell 7, WSL2 Ubuntu 26.04, Zsh, Starship, Fastfetch, Gruvbox.

---

## Preview

<!-- Add screenshots to assets/images/ and reference them here -->
> Screenshots coming soon.

---

## About

This repository is the source of truth for my terminal setup across Windows and WSL. It covers everything from the Windows Terminal color scheme to the Zsh configuration inside Ubuntu 26.04.

The setup is split into two deployment strategies:

- **Windows side** — configs are versioned here and applied by a deploy script (`scripts/deploy-windows.sh`). Avoids fragile symlinks across the Windows/WSL boundary.
- **WSL side** — configs use standard Linux symlinks pointing directly into the repo (`scripts/link-ubuntu.sh`).

---

## Key Features

- Gruvbox color scheme throughout — Windows Terminal, Starship and Fastfetch all share the same palette
- Custom `Mattk Gruvbox Kitty` terminal scheme derived from Kitty's Gruvbox port
- Starship prompt with powerline segments, OS icon and git status
- Fastfetch on shell start for both PowerShell and Zsh
- Minimal PowerShell profile — only Starship init and Fastfetch
- WSL Zsh config with safeguards (`command -v` checks before invoking tools)
- No auto-sourced secrets, no machine-specific tokens in any config

---

## Repository Structure

```
windows/
  terminal/         Windows Terminal settings.json
  powershell/       PowerShell 7 profile
  starship/         Starship config for Windows
  fastfetch/        Fastfetch config for Windows

wsl/
  ubuntu-26.04/
    zsh/            .zshrc
    starship/       Starship config for WSL
    fastfetch/      Fastfetch config for WSL

scripts/
  deploy-windows.sh  Copy Windows configs to their live locations
  link-ubuntu.sh     Create symlinks for WSL configs
```

---

## Managed Files

| File in repo | Live location |
|---|---|
| `windows/terminal/settings.json` | `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json` |
| `windows/powershell/Microsoft.PowerShell_profile.ps1` | `$PROFILE` (CurrentUserCurrentHost) |
| `windows/starship/starship.toml` | `%USERPROFILE%\.config\starship.toml` |
| `windows/fastfetch/config.jsonc` | `%USERPROFILE%\.config\fastfetch\config.jsonc` |
| `wsl/ubuntu-26.04/zsh/.zshrc` | `~/.zshrc` (symlink) |
| `wsl/ubuntu-26.04/starship/starship.toml` | `~/.config/starship.toml` (symlink) |
| `wsl/ubuntu-26.04/fastfetch/config.jsonc` | `~/.config/fastfetch/config.jsonc` (symlink) |

---

## Dependencies

| Tool | Required on |
|---|---|
| [Windows Terminal](https://aka.ms/terminal) | Windows |
| [PowerShell 7](https://github.com/PowerShell/PowerShell) | Windows |
| [Starship](https://starship.rs) | Windows + WSL |
| [Fastfetch](https://github.com/fastfetch-cli/fastfetch) | Windows + WSL |
| [JetBrainsMono Nerd Font](https://www.nerdfonts.com) | Windows (terminal font) |
| WSL2 + Ubuntu 26.04 LTS | Windows |
| Zsh | WSL |

---

## Usage

### Windows deployment

Run from inside WSL, with the repo cloned to `~/Windows_Terminal`:

```bash
bash scripts/deploy-windows.sh
```

This copies `settings.json`, `starship.toml`, `fastfetch/config.jsonc` and the PowerShell profile to their live Windows locations. Restart Windows Terminal after running it.

### WSL Ubuntu setup

Run from inside WSL:

```bash
bash scripts/link-ubuntu.sh
```

This creates symlinks from `~/.zshrc`, `~/.config/starship.toml` and `~/.config/fastfetch/config.jsonc` to the corresponding files in the repo. After linking, reload the shell:

```bash
exec zsh
```

---

## Safety Notes

- No passwords, tokens, SSH keys or `.env` files belong in this repository.
- `deploy-windows.sh` overwrites live configs — back up your current configs before the first run if needed.
- `link-ubuntu.sh` removes any existing file or symlink at the target path before creating the new symlink.
- The scripts reference a hardcoded home directory. Review `REPO` and `WIN_USER` variables before running on a different machine.

---

## Documentation

- [Repository structure](docs/STRUCTURE.md)
- [Full restore guide](docs/RESTORE.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)
- [Changelog](CHANGELOG.md)

---

## License

[MIT](LICENSE)
