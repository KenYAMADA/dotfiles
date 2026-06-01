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
if [ -e "$HOME/.cargo/bin" ]; then
  export PATH=$HOME/.cargo/bin:$PATH
fi

# Flutter
if [ -e "$HOME/development/flutter/bin" ]; then
  export PATH=$HOME/development/flutter/bin:$PATH
fi
export PATH="$PATH:$HOME/.pub-cache/bin"

# mysql client (macOS Homebrew)
if [ -e "/usr/local/opt/mysql-client/bin" ]; then
  export PATH=/usr/local/opt/mysql-client/bin:$PATH
fi

# Android SDK (Android Studio 優先、なければ standalone)
if [ -e "$HOME/Library/Android/sdk" ]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
elif [ -e "$HOME/.android/sdk" ]; then
  export ANDROID_HOME="$HOME/.android/sdk"
fi
if [ -n "$ANDROID_HOME" ]; then
  export ANDROID_SDK_ROOT="$ANDROID_HOME"
  export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools/bin:$PATH"
fi

# Android command-line tools (Homebrew)
_android_cmdline="$(brew --prefix 2>/dev/null)/share/android-commandlinetools/bin"
if [ -d "$_android_cmdline" ]; then
  export PATH="$_android_cmdline:$PATH"
fi
unset _android_cmdline

# History
export HISTFILE="${XDG_STATE_HOME}/zsh/history"
export HISTSIZE=100000
export SAVEHIST=100000

# iTerm2 Shell Integration
if [ -e "${HOME}/.iterm2_shell_integration.zsh" ]; then
  source "${HOME}/.iterm2_shell_integration.zsh"
fi
