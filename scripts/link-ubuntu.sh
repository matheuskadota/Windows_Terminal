#!/usr/bin/env bash
set -euo pipefail

REPO="$HOME/Windows_Terminal"
BACKUP_ROOT="$HOME/.dotfiles-backups"
BACKUP_DIR="$BACKUP_ROOT/$(date +%Y%m%d-%H%M%S)"

mkdir -p "$HOME/.config/fastfetch"

link_file() {
    local source="$1"
    local target="$2"

    if [[ -L "$target" ]]; then
        local resolved_target resolved_source
        resolved_target="$(realpath -m "$target")"
        resolved_source="$(realpath -m "$source")"

        if [[ "$resolved_target" == "$resolved_source" ]]; then
            echo "OK: $target já está linkado."
            return 0
        fi

        mkdir -p "$BACKUP_DIR"
        mv "$target" "$BACKUP_DIR/$(basename "$target").symlink"
        echo "Backup: symlink anterior de $target salvo."
    elif [[ -e "$target" ]]; then
        mkdir -p "$BACKUP_DIR"
        mv "$target" "$BACKUP_DIR/$(basename "$target")"
        echo "Backup: arquivo existente $target salvo."
    fi

    ln -s "$source" "$target"
    echo "Linked: $target -> $source"
}

link_file "$REPO/wsl/ubuntu-26.04/zsh/.zshrc" "$HOME/.zshrc"
link_file "$REPO/wsl/ubuntu-26.04/starship/starship.toml" "$HOME/.config/starship.toml"
link_file "$REPO/wsl/ubuntu-26.04/fastfetch/config.jsonc" "$HOME/.config/fastfetch/config.jsonc"

echo
echo "Ubuntu configs linked."
if [[ -d "$BACKUP_DIR" ]]; then
    echo "Backups criados em: $BACKUP_DIR"
else
    echo "Nenhum backup foi necessário."
fi
echo "Reinicie com: exec zsh"
