#!/usr/bin/env bash
set -e

REPO="$HOME/Windows_Terminal"

mkdir -p "$HOME/.config/fastfetch"

link_file() {
    local source="$1"
    local target="$2"

    if [ -e "$target" ] || [ -L "$target" ]; then
        rm -f "$target"
    fi

    ln -s "$source" "$target"
    echo "Linked: $target -> $source"
}

link_file "$REPO/wsl/ubuntu-26.04/zsh/.zshrc" "$HOME/.zshrc"
link_file "$REPO/wsl/ubuntu-26.04/starship/starship.toml" "$HOME/.config/starship.toml"
link_file "$REPO/wsl/ubuntu-26.04/fastfetch/config.jsonc" "$HOME/.config/fastfetch/config.jsonc"

echo
echo "Ubuntu configs linked."
echo "Reinicie com: exec zsh"
