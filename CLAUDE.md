# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Personal dotfiles for cross-platform development environment setup (macOS, Linux, Windows). Automates shell configuration, package installation, and tool setup.

## Installation Flow

```
# Universal (auto-detects OS)
install.sh → setup.sh → mac_init.sh / linux_init.sh

# macOS-specific
install_mac.sh → setup.sh → mac_init.sh

# Linux-specific
install_linux.sh → setup.sh → linux_init.sh

# Windows
install.ps1 → setup.ps1
```

- `install.sh` — detects OS, clones repo, dispatches to platform installer
- `install_mac.sh` / `install_linux.sh` — platform-specific entry points (clone + setup)
- `setup.sh` — installs packages (Homebrew/apt/dnf/yum/pacman), symlinks dotfiles, installs anyenv
- `mac_init.sh` / `linux_init.sh` — post-setup: iTerm2/Starship, Vim plugins, anyenv plugins, GitHub CLI config
- `setup.ps1` — Windows: installs Starship, copies PowerShell profile

## Platform Architecture

| Concern | macOS | Linux | Windows |
|---|---|---|---|
| Shell | Zsh + Oh My Zsh | Bash | PowerShell |
| Prompt | Powerlevel10k | Starship | Starship |
| Packages | Brewfile | packages/{apt,dnf,pacman}.txt | winget_packages.ps1 |
| Version mgr | anyenv + asdf | anyenv | — |
| Alias file | `.zshrc.alias` | `.bashrc.alias` | — |

## Key File Relationships

- `.zshrc` sources `.zshenv` implicitly; both are symlinked to `$HOME` by `setup.sh`
- `.zshrc.alias` is shared across platforms and sourced in both `.zshrc` and `.zshenv`
- `.bashrc.alias` is the Linux/Bash equivalent of `.zshrc.alias`
- `starship.toml` is copied (not symlinked) to `~/.config/starship.toml` on Linux/Windows
- `gh/config.yml` is symlinked to `~/.config/gh/config.yml`
- `.bin/` directory is symlinked to `~/.bin/` and added to PATH in `.zshenv`
  - `showenv` — prints PATH entries one per line
  - `cloud_sql_proxy` — Cloud SQL Proxy binary

## Shell Configuration Details

**macOS `.zshrc`** loads in this order:
1. Google Cloud SDK (multiple fallback paths for Homebrew vs manual install)
2. Powerlevel10k instant prompt preamble
3. Android Studio IntelliJ env check (`ZSH_TMUX_AUTOSTART`)
4. Oh My Zsh (plugins: git, zsh-autosuggestions, zsh-completions, zsh-syntax-highlighting)
5. `.zshrc.alias`
6. iTerm2 Shell Integration
7. Docker CLI completions
8. LM Studio CLI PATH
9. kiro shell integration
10. p10k config (`~/.p10k.zsh`)
11. anyenv init (with guard: only if `~/.anyenv` exists)
12. Android Studio Java PATH (with guard: only if Android Studio installed)
13. asdf init (with guard: only if `$(brew --prefix asdf)/libexec/asdf.sh` exists)
14. Antigravity PATH
15. OpenClaw shell completion

**Linux `.bashrc`** includes color detection with `TERM=dumb` fallback to avoid broken terminals.

## Optional Scripts (`scripts/`)

These are not run automatically — invoke manually as needed:

| Script | Purpose |
|--------|---------|
| `setup_gcloud.sh` | Google Cloud SDK (Homebrew, Python 3.14 compatibility) |
| `setup_aws.sh` | AWS CLI setup |
| `setup_heroku.sh` | Heroku CLI setup |
| `setup_node.sh` | Node.js via nvm |
| `setup_zsh.sh` | Oh My Zsh installation |
| `setup_editor_fonts.sh` | Configure MesloLGS NF font in VSCode, Cursor, Windsurf |
| `setup_cursor_fonts.sh` | Configure fonts for Cursor only |
| `setup_vscode_fonts.sh` | Configure fonts for VSCode only |
| `setup_windsurf_fonts.sh` | Configure fonts for Windsurf only |
| `setup_terminal_fonts.sh` | Configure fonts for Terminal.app and iTerm2 |
| `setup_iterm2_profile.sh` | Create iTerm2 profile with font settings |
| `merge_editor_settings.sh` | Safe JSON merge (backs up existing settings, adds only missing keys) |

Editor settings templates: `cursor_settings.json`, `vscode_settings.json`, `windsurf_settings.json`

## Prompt / Theme

- **macOS:** Powerlevel10k — requires MesloLGS NF font
- **Linux/Windows:** Starship with Gruvbox Dark palette (`starship.toml`)
- The starship config uses emoji directory substitutions and shows language versions (Node, Go, Rust, Python, PHP), Docker context, and time

## Aliases (`.zshrc.alias`)

- `ls`/`l`/`ll`/`la`/`et`/`lt` — `eza` wrappers (falls back to system `ls` if eza unavailable)
- `mkdir` — always `-p`
- `gocover()` — function to generate Go coverage HTML report
