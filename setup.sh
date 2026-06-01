#!/bin/bash

DOTPATH=$HOME/dotfiles
# OS-specific dotfiles (.zshrc is handled separately via ZDOTDIR)
case ${OSTYPE} in
  darwin*)
    DOT_FILES=(.bin .zshenv .vimrc)
    ;;
  linux*)
    DOT_FILES=(.bin .zshenv .vimrc)
    ;;
esac

## Zsh setup
case ${OSTYPE} in
  darwin*)
    echo "Set zsh"
    chsh -s /bin/zsh
    echo "Install commandline tool"
    xcode-select --install > /dev/null 2>&1 || true # Add || true to prevent script from exiting if already installed
    echo "installing Homebrew ..."
    which brew >/dev/null 2>&1 || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    echo "run brew update & upgrade ..."
    brew update && brew upgrade
    
    echo "Installing packages from Brewfile..."
    brew bundle --file="$DOTPATH/Brewfile" # Specify the path to the Brewfile
    brew cleanup
    ;;
  linux*)
    echo "Linux environment detected. Setting up zsh environment..."

    # Determine package manager and install essential packages
    INSTALL_CMD=""
    UPDATE_CMD=""
    PKG_LIST_FILE=""

    if command -v apt-get &> /dev/null; then
      INSTALL_CMD="sudo apt-get install -y"
      UPDATE_CMD="sudo apt-get update && sudo apt-get upgrade -y"
      PKG_LIST_FILE="$DOTPATH/packages/apt.txt"
    elif command -v dnf &> /dev/null; then
      INSTALL_CMD="sudo dnf install -y"
      UPDATE_CMD="sudo dnf upgrade -y"
      PKG_LIST_FILE="$DOTPATH/packages/dnf.txt"
    elif command -v yum &> /dev/null; then
      INSTALL_CMD="sudo yum install -y"
      UPDATE_CMD="sudo yum upgrade -y"
      PKG_LIST_FILE="$DOTPATH/packages/dnf.txt"
    elif command -v pacman &> /dev/null; then
      INSTALL_CMD="sudo pacman -S --noconfirm"
      UPDATE_CMD="sudo pacman -Syu --noconfirm"
      PKG_LIST_FILE="$DOTPATH/packages/pacman.txt"
    fi

    # Update packages
    if [ -n "$UPDATE_CMD" ]; then
      echo "Updating system packages..."
      eval "$UPDATE_CMD"
    fi

    # Install packages from list
    if [ -n "$INSTALL_CMD" ] && [ -s "$PKG_LIST_FILE" ]; then
      echo "Installing packages from $PKG_LIST_FILE..."
      grep -vE '^\s*#|^\s*$' "$PKG_LIST_FILE" | xargs $INSTALL_CMD
    else
      echo "Package list file not found or is empty. Skipping package installation."
    fi

    # Set zsh as default shell
    ZSH_PATH=$(command -v zsh 2>/dev/null)
    if [ -n "$ZSH_PATH" ]; then
      echo "Setting default shell to zsh..."
      grep -qxF "$ZSH_PATH" /etc/shells || echo "$ZSH_PATH" | sudo tee -a /etc/shells
      sudo chsh -s "$ZSH_PATH" "$USER"
    else
      echo "Warning: zsh not found. Install zsh and re-run to set as default shell." >&2
    fi

    echo "Linux zsh setup complete."
    ;;
esac

## Shell setup (OS-specific)
case ${OSTYPE} in
  darwin*)
    ## Oh My Zsh setup for macOS
    echo "Setting up Oh My Zsh environment..."
    # Ensure script has execute permission
    if [ ! -x "$DOTPATH/scripts/setup_zsh.sh" ]; then
        chmod +x "$DOTPATH/scripts/setup_zsh.sh"
    fi
    bash "$DOTPATH/scripts/setup_zsh.sh"
    ;;
  linux*)
    ## Zsh + Oh My Zsh setup for Linux
    echo "Setting up Oh My Zsh environment..."
    if [ ! -x "$DOTPATH/scripts/setup_zsh.sh" ]; then
        chmod +x "$DOTPATH/scripts/setup_zsh.sh"
    fi
    bash "$DOTPATH/scripts/setup_zsh.sh"
    ;;
esac
## XDG state dir for zsh history
mkdir -p "$HOME/.local/state/zsh"

## .zshrc → ~/.config/zsh/.zshrc (ZDOTDIR)
mkdir -p "$HOME/.config/zsh"
if [ -e "$HOME/.config/zsh/.zshrc" ] && [ ! -L "$HOME/.config/zsh/.zshrc" ]; then
  mv "$HOME/.config/zsh/.zshrc" "$HOME/.config/zsh/.zshrc.org"
fi
ln -snf "$DOTPATH/.zshrc" "$HOME/.config/zsh/.zshrc"
printf "    %-25s -> %s\n" "$DOTPATH/.zshrc" "$HOME/.config/zsh/.zshrc"

## p10k.zsh → ~/.config/p10k.zsh (macOS only)
case ${OSTYPE} in
  darwin*)
    mkdir -p "$HOME/.config"
    if [ -e "$HOME/.config/p10k.zsh" ] && [ ! -L "$HOME/.config/p10k.zsh" ]; then
      mv "$HOME/.config/p10k.zsh" "$HOME/.config/p10k.zsh.org"
    fi
    ln -snf "$DOTPATH/p10k.zsh" "$HOME/.config/p10k.zsh"
    printf "    %-25s -> %s\n" "$DOTPATH/p10k.zsh" "$HOME/.config/p10k.zsh"
    ;;
esac

## Claude Code config → ~/.claude/
mkdir -p "$HOME/.claude"
for file in settings.json CLAUDE.md RTK.md statusline.sh; do
  src="$DOTPATH/claude/$file"
  dest="$HOME/.claude/$file"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    mv "$dest" "${dest}.org"
  fi
  ln -snf "$src" "$dest"
  printf "    %-25s -> %s\n" "$src" "$dest"
done

## dotfile
for file in "${DOT_FILES[@]}" # Quote array for safety
do
  # Improved backup process
  if [ -e "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
    mv "$HOME/$file" "$HOME/$file.org"
  fi
  ln -snf "$DOTPATH/$file" "$HOME/$file"
  if [ $? -eq 0 ]; then
    printf "    %-25s -> %s\n" "$DOTPATH/$file" "$HOME/$file"
  fi   
done

## anyenv install (XDG: ~/.local/share/anyenv)
ANYENV_ROOT="${XDG_DATA_HOME:-$HOME/.local/share}/anyenv"
if [ ! -d "$ANYENV_ROOT" ]; then
    git clone https://github.com/anyenv/anyenv "$ANYENV_ROOT"
fi

# Ensure anyenv is available for the current script execution
if [ -d "$ANYENV_ROOT" ]; then
    export ANYENV_ROOT
    export PATH="$ANYENV_ROOT/bin:$PATH"
    if command -v anyenv &> /dev/null; then
        eval "$(anyenv init -)"
        if [ ! -d "$ANYENV_ROOT/plugins/anyenv-install" ]; then
            echo "Initializing anyenv definitions..."
            anyenv install --init
        fi
        export ANYENV_DEFINITION_ROOT="$ANYENV_ROOT/plugins/anyenv-install"
    else
        echo "Warning: anyenv command not found after adding to PATH. Please check anyenv installation." >&2
    fi
fi

## Platform specific init
case ${OSTYPE} in
  darwin*)
    # Ensure script has execute permission
    if [ ! -x "$DOTPATH/mac_init.sh" ]; then
        chmod +x "$DOTPATH/mac_init.sh"
    fi
    bash "$DOTPATH/mac_init.sh"
    ;;
  linux*)
    # Ensure script has execute permission
    if [ ! -x "$DOTPATH/linux_init.sh" ]; then
        chmod +x "$DOTPATH/linux_init.sh"
    fi
    bash "$DOTPATH/linux_init.sh"
    ;;
esac
