#!/usr/bin/env bash
set -e

REPO="$HOME/Windows_Terminal"
WIN_USER="/mnt/c/Users/Mattk"
WT_SETTINGS="$WIN_USER/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
PWSH="/mnt/c/Program Files/PowerShell/7/pwsh.exe"

mkdir -p "$WIN_USER/.config/fastfetch"

cp "$REPO/windows/terminal/settings.json" "$WT_SETTINGS"
cp "$REPO/windows/starship/starship.toml" "$WIN_USER/.config/starship.toml"
cp "$REPO/windows/fastfetch/config.jsonc" "$WIN_USER/.config/fastfetch/config.jsonc"

"$PWSH" -NoLogo -NoProfile -Command '
$profilePath = $PROFILE.CurrentUserCurrentHost

if (!(Test-Path (Split-Path $profilePath))) {
    New-Item -ItemType Directory -Force (Split-Path $profilePath) | Out-Null
}

Copy-Item "\\wsl$\Ubuntu-26.04\home\mattk\Windows_Terminal\windows\powershell\Microsoft.PowerShell_profile.ps1" $profilePath -Force
'

echo
echo "Windows configs deployed."
echo "Feche e abra novamente o Windows Terminal."
