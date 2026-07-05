# Repository Structure

This document describes every directory and file tracked in this repository.

---

## Top-level layout

```
Windows_Terminal/
├── windows/
├── wsl/
├── scripts/
├── docs/
├── assets/
├── .gitignore
├── CHANGELOG.md
├── LICENSE
└── README.md
```

---

## windows/

Configs deployed to the Windows side via `scripts/deploy-windows.sh`.

```
windows/
├── terminal/
│   └── settings.json
├── powershell/
│   └── Microsoft.PowerShell_profile.ps1
├── starship/
│   └── starship.toml
└── fastfetch/
    └── config.jsonc
```

### windows/terminal/

`settings.json` — Windows Terminal configuration.

- Default profile: Ubuntu 26.04 (WSL)
- Profiles: Ubuntu 26.04, PowerShell 7, CMD; legacy Windows PowerShell and Azure Cloud Shell hidden
- Color scheme: `Mattk Gruvbox Kitty` (custom, defined inline in `schemes`)
- Font: JetBrainsMono NF, 12pt
- Window: 135×35 columns/rows

### windows/powershell/

`Microsoft.PowerShell_profile.ps1` — PowerShell 7 profile.

- Initializes Starship prompt
- Runs Fastfetch on start

### windows/starship/

`starship.toml` — Starship prompt configuration for the Windows/PowerShell environment.

- Powerline-style segments: OS icon → directory → git → language versions → docker
- Gruvbox palette (orange, yellow, green, blue)
- Two-line prompt with `»` character symbol

### windows/fastfetch/

`config.jsonc` — Fastfetch configuration for Windows.

- Logo colors in Gruvbox blue (`#83a598`)
- Displays: OS, kernel, uptime, shell, terminal, CPU, GPU, memory, disk, color swatches

---

## wsl/

Configs deployed to WSL via symlinks created by `scripts/link-ubuntu.sh`.

```
wsl/
└── ubuntu-26.04/
    ├── zsh/
    │   └── .zshrc
    ├── starship/
    │   └── starship.toml
    └── fastfetch/
        └── config.jsonc
```

### wsl/ubuntu-26.04/

All files under this directory target the Ubuntu 26.04 WSL distribution.

#### wsl/ubuntu-26.04/zsh/

`.zshrc` — Zsh shell configuration.

- Sets `STARSHIP_CONFIG` to `~/.config/starship.toml`
- Initializes Starship only if `starship` is in `PATH`
- Runs Fastfetch on interactive shells only if `fastfetch` is in `PATH`

#### wsl/ubuntu-26.04/starship/

`starship.toml` — Starship prompt configuration for the WSL/Zsh environment.

- Powerline segments: OS icon → directory → git → Node.js → Python
- Gruvbox palette
- Uses Unicode escape sequences for Nerd Font glyphs

#### wsl/ubuntu-26.04/fastfetch/

`config.jsonc` — Fastfetch configuration for WSL.

- Logo colors in Gruvbox orange (`#fe8019`)
- Displays: OS, kernel, uptime, packages, shell, terminal, CPU, GPU, memory, disk, color swatches

---

## scripts/

Deployment scripts. Neither script modifies the repository itself.

```
scripts/
├── deploy-windows.sh
└── link-ubuntu.sh
```

### scripts/deploy-windows.sh

Copies Windows-side configs from the repo to their live locations on the Windows filesystem, accessed via `/mnt/c`. Also copies the PowerShell profile using `pwsh.exe -Command Copy-Item`.

Hardcoded variables at the top of the script:
- `REPO` — expected to be `$HOME/Windows_Terminal`
- `WIN_USER` — path to the Windows user profile under `/mnt/c/Users/`

### scripts/link-ubuntu.sh

Creates symlinks in the WSL home directory pointing to the repo files:

| Symlink | Target in repo |
|---|---|
| `~/.zshrc` | `wsl/ubuntu-26.04/zsh/.zshrc` |
| `~/.config/starship.toml` | `wsl/ubuntu-26.04/starship/starship.toml` |
| `~/.config/fastfetch/config.jsonc` | `wsl/ubuntu-26.04/fastfetch/config.jsonc` |

Existing files or symlinks at target paths are removed before the new symlink is created.

---

## docs/

Documentation files.

```
docs/
├── STRUCTURE.md     (this file)
├── RESTORE.md
└── TROUBLESHOOTING.md
```

---

## assets/

Static assets referenced from documentation.

```
assets/
└── images/
    └── .gitkeep     (placeholder for future screenshots)
```
