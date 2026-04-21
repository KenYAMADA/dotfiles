# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Personal dotfiles for cross-platform development environment setup (macOS, Linux, Windows). Automates shell configuration, package installation, and tool setup.

## Installation Flow

```
install.sh → setup.sh → mac_init.sh / linux_init.sh
```

- `install.sh` — detects OS, clones repo, dispatches to platform installer
- `setup.sh` — installs packages (Homebrew/apt/dnf/yum/pacman/winget), symlinks dotfiles, installs anyenv
- `mac_init.sh` / `linux_init.sh` — post-setup: iTerm2/Starship, Vim plugins, anyenv plugins, GitHub CLI config
- `setup.ps1` — Windows: installs Starship, copies PowerShell profile

## Platform Architecture

| Concern | macOS | Linux | Windows |
|---|---|---|---|
| Shell | Zsh + Oh My Zsh | Bash | PowerShell |
| Prompt | Powerlevel10k | Starship | Starship |
| Packages | Brewfile | packages/{apt,dnf,pacman}.txt | winget_packages.ps1 |
| Version mgr | anyenv | anyenv | — |

## Key File Relationships

- `.zshrc` sources `.zshenv` implicitly; both are symlinked to `$HOME` by `setup.sh`
- `.zshrc.alias` is shared across platforms and sourced in both `.zshrc` and `.bashrc`
- `starship.toml` is copied (not symlinked) to `~/.config/starship.toml` on Linux/Windows
- `gh/config.yml` is symlinked to `~/.config/gh/config.yml`
- `.bin/` directory is symlinked to `~/.bin/` and added to PATH in `.zshenv`

## Shell Configuration Details

**macOS `.zshrc`** loads in this order:
1. Powerlevel10k instant prompt
2. PATH additions (anyenv, Flutter, Android, MySQL, Cargo, LM Studio, `.bin`)
3. Oh My Zsh (plugins: git, zsh-autosuggestions, zsh-completions, zsh-syntax-highlighting)
4. `.zshrc.alias`
5. Google Cloud SDK (multiple fallback paths for Homebrew vs manual install)
6. Tool completions (Docker, etc.)

**Linux `.bashrc`** includes color detection with `TERM=dumb` fallback to avoid broken terminals.

## Optional Scripts (`scripts/`)

These are not run automatically — invoke manually as needed:
- `setup_gcloud.sh` — Google Cloud SDK (Homebrew, Python 3.14 compatibility)
- `setup_aws.sh` / `setup_heroku.sh` — Cloud CLI tools
- `setup_zsh.sh` — Oh My Zsh installation
- `setup_editor_fonts.sh` — Configure MesloLGS NF font in VSCode, Cursor, Windsurf
- `merge_editor_settings.sh` — Safe JSON merge (backs up existing settings, adds only missing keys)

## Prompt / Theme

- **macOS:** Powerlevel10k — requires MesloLGS NF font
- **Linux/Windows:** Starship with Gruvbox Dark palette (`starship.toml`)
- The starship config uses emoji directory substitutions and shows language versions (Node, Go, Rust, Python, PHP), Docker context, and time

## Aliases (`.zshrc.alias`)

- `ls`/`l`/`ll`/`la`/`et`/`lt` — `eza` wrappers (falls back to system `ls` if eza unavailable)
- `mkdir` — always `-p`
- `gocover()` — function to generate and open Go coverage reports in browser
