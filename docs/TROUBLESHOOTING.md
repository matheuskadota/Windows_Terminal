# Troubleshooting

Common issues and fixes for this terminal setup.

---

## Windows Terminal profile not loading

**Symptom:** Windows Terminal opens but the Ubuntu 26.04 profile is missing or shows an error.

**Check:**
1. Confirm WSL2 is installed and the distro exists: `wsl --list --verbose`
2. Confirm the distro name matches exactly — the profile uses `Ubuntu-26.04`
3. Open Windows Terminal settings and check that `disabledProfileSources` does not include `Windows.Terminal.Wsl` (the `settings.json` in this repo already disables auto-detection to avoid duplicates)

**Fix:** Re-run the deploy script to overwrite `settings.json`, then restart Windows Terminal:

```bash
bash scripts/deploy-windows.sh
```

---

## PowerShell profile not loading

**Symptom:** PowerShell 7 opens without Starship or Fastfetch.

**Check:**

```powershell
Test-Path $PROFILE
cat $PROFILE
```

**Fix:** Re-run the deploy script. If `Test-Path` returns false, the deploy script will create the directory and file automatically. If the profile file exists but is empty or incorrect, the script overwrites it.

---

## Execution policy blocking scripts

**Symptom:** PowerShell refuses to load the profile with an error about execution policy.

**Fix:** Set the execution policy for the current user:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

`RemoteSigned` allows local scripts to run and requires a signature only for scripts downloaded from the internet.

---

## Nerd Font icons missing

**Symptom:** Starship prompt shows boxes, question marks or missing glyphs instead of icons.

**Check:** Windows Terminal → Settings → the active profile → Appearance → Font face. Should be `JetBrainsMono NF` or another Nerd Font variant.

**Fix:**
1. Download [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads)
2. Extract and install all `.ttf` files (right-click → Install for all users)
3. In Windows Terminal Settings, set font face to `JetBrainsMono NF`
4. The `settings.json` in this repo already sets the font — re-running the deploy script will restore it

---

## Starship not loading

**Symptom:** Plain shell prompt instead of the Starship powerline segments.

**Windows:**
- Confirm Starship is installed: `starship --version` in PowerShell
- Confirm the profile loads it: `cat $PROFILE` should show `Invoke-Expression (&starship init powershell)`
- Confirm `starship` is in `$env:PATH`

**WSL:**
- Confirm Starship is installed: `starship --version` in Zsh
- The `.zshrc` checks `command -v starship` before initializing — if Starship is not in `PATH` it silently skips
- Confirm the symlink exists: `ls -la ~/.config/starship.toml`

**Fix (WSL):** Install Starship:

```bash
curl -sS https://starship.rs/install.sh | sh
exec zsh
```

---

## Fastfetch not found

**Symptom:** No system info on shell start, or `fastfetch: command not found`.

**Windows:**
- Download the Fastfetch release binary from [GitHub releases](https://github.com/fastfetch-cli/fastfetch/releases)
- Place it somewhere on `$env:PATH` (e.g. `C:\Tools\`)

**WSL:**
```bash
sudo apt install fastfetch
```

If the package is not available in your apt sources, build from source or use the GitHub release binary for Linux.

The `.zshrc` in this repo checks `command -v fastfetch` before running it, so a missing binary will not cause startup errors — Fastfetch simply will not run.

---

## WSL symlinks not working

**Symptom:** `link-ubuntu.sh` runs without errors but the configs are not picked up, or `ls -la` shows a broken symlink.

**Check:**
```bash
ls -la ~/.zshrc ~/.config/starship.toml ~/.config/fastfetch/config.jsonc
```

A broken symlink points to a path that does not exist. The most likely cause is that the repo is not at `~/Windows_Terminal`.

**Fix:** Either clone or move the repo to `~/Windows_Terminal`, or edit the `REPO` variable at the top of `scripts/link-ubuntu.sh` to point to the actual location, then re-run the script.

---

## Wrong paths between Windows and WSL

**Symptom:** The deploy script fails when accessing `/mnt/c/Users/...` — `No such file or directory`.

**Cause:** The `WIN_USER` variable in `deploy-windows.sh` is hardcoded to `/mnt/c/Users/Mattk`. On a different machine the username will be different.

**Fix:** Edit `deploy-windows.sh` and update `WIN_USER` to match your Windows username:

```bash
WIN_USER="/mnt/c/Users/<your-username>"
```

Also update the WSL UNC path inside the `pwsh.exe` command block:

```
\\wsl$\Ubuntu-26.04\home\<your-wsl-username>\Windows_Terminal\...
```

---

## Script permission issues

**Symptom:** `bash scripts/deploy-windows.sh` or `bash scripts/link-ubuntu.sh` fails with `Permission denied`.

**Fix:** The scripts are invoked via `bash` explicitly, so they do not need the executable bit. If you want to run them directly (`./scripts/deploy-windows.sh`), add the execute bit:

```bash
chmod +x scripts/deploy-windows.sh scripts/link-ubuntu.sh
```

If the error is about writing to `/mnt/c/...`, WSL may not have write access to the Windows filesystem. Ensure WSL2 is configured correctly and that the Windows path is mounted with write permissions (`/etc/wsl.conf` mount options).
