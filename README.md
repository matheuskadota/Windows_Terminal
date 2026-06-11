# Windows_Terminal

Configuração pessoal do Windows Terminal com PowerShell 7, WSL2 Ubuntu 26.04, Zsh, Starship, Fastfetch e tema Gruvbox inspirado no setup Kitty/Arch.

## Estrutura

```text
windows/
  terminal/
  powershell/
  starship/
  fastfetch/

wsl/
  ubuntu-26.04/
    zsh/
    starship/
    fastfetch/

scripts/
  link-ubuntu.sh
  deploy-windows.sh
```

## Filosofia

O repositório é a fonte da verdade.

No Ubuntu/WSL, as configs usam symlink direto para o repo.

No Windows, as configs ficam versionadas no repo e são aplicadas via script de deploy, evitando symlinks frágeis entre Windows e WSL.

## Componentes

- Windows Terminal
- PowerShell 7
- WSL2 Ubuntu 26.04 LTS
- Zsh
- Starship
- Fastfetch
- JetBrainsMono Nerd Font
- Gruvbox

## Paleta principal

```text
background: #32302f
foreground: #ebdbb2
orange:     #fe8019
yellow:     #fabd2f
green:      #8ec07c
blue:       #83a598
```

## Uso

Aplicar links no Ubuntu:

```bash
./scripts/link-ubuntu.sh
```

Aplicar configs no Windows:

```bash
./scripts/deploy-windows.sh
```

## Observação

Este repositório contém somente configurações visuais e de shell.

Não incluir senhas, tokens, chaves SSH, arquivos `.env` ou dados privados.
