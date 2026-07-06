# Restore Guide

How to restore this setup on a clean Windows + WSL environment.

---

## Required tools

Install these before running any scripts.

**Windows side**

- [Windows Terminal](https://aka.ms/terminal) — from the Microsoft Store or winget
- [PowerShell 7](https://github.com/PowerShell/PowerShell/releases) — installed to `C:\Program Files\PowerShell\7\`
- [Starship](https://starship.rs) — `winget install Starship.Starship` or the installer from the site
- [Fastfetch](https://github.com/fastfetch-cli/fastfetch/releases) — add the binary to your `PATH`
- [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads) — install the font family to Windows, then set it in Windows Terminal

**WSL side**

- WSL2 with Ubuntu 26.04 LTS — `wsl --install -d Ubuntu-26.04`
- Zsh — `sudo apt install zsh`
- Starship — `curl -sS https://starship.rs/install.sh | sh`
- Fastfetch — `sudo apt install fastfetch` or build from source

---

## Clone the repository

Clone to your WSL home directory (scripts expect `~/Windows_Terminal`):

```bash
git clone https://github.com/matheuskadota/Windows_Terminal.git ~/Windows_Terminal
cd ~/Windows_Terminal
```

---

## Windows Terminal setup

Run the deploy script from WSL:

```bash
bash scripts/deploy-windows.sh
```

This copies `windows/terminal/settings.json` to the Windows Terminal `LocalState` directory. Restart Windows Terminal for the changes to take effect.

To verify: open Windows Terminal Settings → the `Mattk Gruvbox Kitty` scheme should appear and Ubuntu 26.04 should be the default profile.

---

## PowerShell setup

The deploy script also copies the PowerShell profile. To verify inside PowerShell 7:

```powershell
cat $PROFILE
```

Expected output:

```powershell
Invoke-Expression (&starship init powershell)
fastfetch
```

If Starship and Fastfetch are in your Windows `PATH`, the prompt and system info should appear on the next PowerShell launch.

---

## Starship setup

For Windows, the deploy script copies `windows/starship/starship.toml` to `%USERPROFILE%\.config\starship.toml`.

To verify in PowerShell:

```powershell
starship --version
```

The Starship prompt should load automatically via the PowerShell profile.

For WSL, `link-ubuntu.sh` symlinks `wsl/ubuntu-26.04/starship/starship.toml` to `~/.config/starship.toml`. The `.zshrc` explicitly sets `STARSHIP_CONFIG` to that path, so no extra configuration is needed.

---

## Fastfetch setup

For Windows, the deploy script copies `windows/fastfetch/config.jsonc` to `%USERPROFILE%\.config\fastfetch\config.jsonc`.

To verify in PowerShell:

```powershell
fastfetch --version
fastfetch
```

For WSL, `link-ubuntu.sh` symlinks `wsl/ubuntu-26.04/fastfetch/config.jsonc` to `~/.config/fastfetch/config.jsonc`.

To verify in Zsh:

```bash
fastfetch --version
fastfetch
```

---

## WSL Ubuntu setup

Run from inside WSL:

```bash
bash scripts/link-ubuntu.sh
```

Reload the shell:

```bash
exec zsh
```

The script creates three symlinks:

```
~/.zshrc                        -> ~/Windows_Terminal/wsl/ubuntu-26.04/zsh/.zshrc
~/.config/starship.toml         -> ~/Windows_Terminal/wsl/ubuntu-26.04/starship/starship.toml
~/.config/fastfetch/config.jsonc -> ~/Windows_Terminal/wsl/ubuntu-26.04/fastfetch/config.jsonc
```

---

## Verification steps

After completing all steps above, verify each component:

**Windows Terminal**

- Default profile opens Ubuntu 26.04 LTS
- Background is dark (`#32302F`), foreground is cream (`#EBDBB2`)
- Font is JetBrainsMono NF

**PowerShell 7**

- Starship prompt loads with powerline segments
- Fastfetch output appears on startup

**WSL Zsh**

- Starship prompt loads with powerline segments
- Fastfetch output appears on startup
- All three config paths are symlinks (see symlink check below)

**Symlink check:**

```bash
ls -la ~/.zshrc ~/.config/starship.toml ~/.config/fastfetch/config.jsonc
```

Each line should show `-> /home/<user>/Windows_Terminal/wsl/ubuntu-26.04/...` and have the `l` permission bit.

---

## Rollback / Safety notes

- Both scripts create automatic timestamped backups before overwriting anything — no manual backup is required before the first run:
  - `deploy-windows.sh` backs up existing Windows configs and the PowerShell profile to `%USERPROFILE%\.dotfiles-backups\<timestamp>\` before copying new ones.
  - `link-ubuntu.sh` backs up existing files or symlinks to `~/.dotfiles-backups/<timestamp>/` before creating new symlinks.

- To undo WSL symlinks and restore your old files:

  ```bash
  rm ~/.zshrc ~/.config/starship.toml ~/.config/fastfetch/config.jsonc
  # copy the files back from ~/.dotfiles-backups/<timestamp>/
  ```

- To undo a Windows deploy, copy the files back from `%USERPROFILE%\.dotfiles-backups\<timestamp>\` to their original locations.

- The scripts hardcode `WIN_USER=/mnt/c/Users/Mattk` and expect the repo at `$HOME/Windows_Terminal`. Edit these variables at the top of each script before running on a different machine.
