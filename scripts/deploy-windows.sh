#!/usr/bin/env bash
set -euo pipefail

REPO="$HOME/Windows_Terminal"
WIN_USER="/mnt/c/Users/Mattk"
WT_SETTINGS="$WIN_USER/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
PWSH="/mnt/c/Program Files/PowerShell/7/pwsh.exe"
BACKUP_DIR="$WIN_USER/.dotfiles-backups/$(date +%Y%m%d-%H%M%S)"

mkdir -p "$WIN_USER/.config/fastfetch"

backup_and_copy() {
    local source="$1"
    local target="$2"

    if [[ -e "$target" ]]; then
        mkdir -p "$BACKUP_DIR"
        cp "$target" "$BACKUP_DIR/$(basename "$target")"
        echo "Backup: $target salvo."
    fi

    cp "$source" "$target"
    echo "Copied: $target"
}

backup_and_copy "$REPO/windows/terminal/settings.json" "$WT_SETTINGS"
backup_and_copy "$REPO/windows/starship/starship.toml" "$WIN_USER/.config/starship.toml"
backup_and_copy "$REPO/windows/fastfetch/config.jsonc" "$WIN_USER/.config/fastfetch/config.jsonc"

"$PWSH" -NoLogo -NoProfile -Command '
$profilePath = $PROFILE.CurrentUserCurrentHost
$backupDir = Join-Path $env:USERPROFILE (".dotfiles-backups\" + (Get-Date -Format "yyyyMMdd-HHmmss"))

if (!(Test-Path (Split-Path $profilePath))) {
    New-Item -ItemType Directory -Force (Split-Path $profilePath) | Out-Null
}

if (Test-Path $profilePath) {
    New-Item -ItemType Directory -Force $backupDir | Out-Null
    Copy-Item $profilePath (Join-Path $backupDir (Split-Path $profilePath -Leaf))
    Write-Host "Backup do profile anterior salvo em $backupDir"
}

Copy-Item "\\wsl$\Ubuntu-26.04\home\mattk\Windows_Terminal\windows\powershell\Microsoft.PowerShell_profile.ps1" $profilePath -Force
'

echo
echo "Windows configs deployed."
if [[ -d "$BACKUP_DIR" ]]; then
    echo "Backups criados em: $BACKUP_DIR"
else
    echo "Nenhum backup foi necessário."
fi
echo "Feche e abra novamente o Windows Terminal."
