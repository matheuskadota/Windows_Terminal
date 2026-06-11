
# >>> MATTK TERMINAL SETUP
export STARSHIP_CONFIG="$HOME/.config/starship.toml"

if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

if [[ -o interactive ]] && command -v fastfetch >/dev/null 2>&1; then
    fastfetch
fi
# <<< MATTK TERMINAL SETUP
