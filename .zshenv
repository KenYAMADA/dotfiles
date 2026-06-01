# XDG Base Directory Specification
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# zsh config を XDG config dir へ（.zshrc を ~/.config/zsh/.zshrc で読む）
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"

# Dotfiles パス
export DOTPATH="$HOME/dotfiles"

# Oh My Zsh (XDG data dir)
export ZSH="${XDG_DATA_HOME}/oh-my-zsh"

# anyenv (XDG data dir)
export ANYENV_ROOT="${XDG_DATA_HOME}/anyenv"

# PATH: Apple Silicon Homebrew → Intel Homebrew → .bin → .local/bin
case ${OSTYPE} in
  darwin*)
    export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:$PATH
    ;;
esac
export PATH=$HOME/.bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Rust
[ -e "$HOME/.cargo/bin" ] && export PATH=$HOME/.cargo/bin:$PATH

# Flutter
[ -e "$HOME/development/flutter/bin" ] && export PATH=$HOME/development/flutter/bin:$PATH
export PATH="$PATH:$HOME/.pub-cache/bin"

# mysql client (macOS Homebrew)
[ -e "/usr/local/opt/mysql-client/bin" ] && export PATH=/usr/local/opt/mysql-client/bin:$PATH

# Android SDK
if [ -e "$HOME/Library/Android/sdk" ]; then
  export ANDROID_HOME=$HOME/Library/Android/sdk
  export PATH=$ANDROID_HOME/tools/bin/sdkmanager:$ANDROID_HOME/tools/bin/avdmanager:$PATH
fi

# History
export HISTFILE="${XDG_STATE_HOME}/zsh/history"
export HISTSIZE=100000
export SAVEHIST=100000

# iTerm2 Shell Integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
