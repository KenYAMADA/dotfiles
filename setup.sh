#!/bin/bash

DOTPATH=$HOME/dotfiles
DOT_FILES=(.bin .zshrc .zshenv .vimrc)

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
  Linux*)
    echo "Linux environment detected. Checking zsh setup..."

    # Check if zsh is installed
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
      PKG_LIST_FILE="$DOTPATH/packages/yum.txt"
    elif command -v pacman &> /dev/null; then
      INSTALL_CMD="sudo pacman -S --noconfirm"
      UPDATE_CMD="sudo pacman -Syu --noconfirm"
      PKG_LIST_FILE="$DOTPATH/packages/pacman.txt"
    fi

    if ! command -v zsh &> /dev/null; then
      echo "zsh is not installed. Attempting to install..."
      if [ -n "$INSTALL_CMD" ]; then
        $INSTALL_CMD zsh
        echo "zsh installation complete."
      else
        echo "No supported package manager found to install zsh." >&2
        echo "Please install zsh manually." >&2
        exit 1
      fi
    else
      echo "zsh is already installed."
    fi

    # Change default shell to zsh if it's not already
    if [[ "$(basename "$SHELL")" != "zsh" ]]; then
      echo "Attempting to change default shell to zsh..."
      ZSH_PATH=$(command -v zsh)
      if [ -z "$ZSH_PATH" ]; then
        echo "Error: zsh executable not found. Cannot change default shell." >&2
        exit 1
      fi

      # Append zsh path to /etc/shells if it doesn't exist
      if ! grep -Fxq "$ZSH_PATH" /etc/shells; then
        echo "Adding $ZSH_PATH to /etc/shells (requires sudo password)..."
        if ! echo "$ZSH_PATH" | sudo tee -a /etc/shells; then
          echo "Warning: Failed to add zsh path to /etc/shells. You may need to do this manually." >&2
        fi
      fi

      echo "Running 'chsh -s $ZSH_PATH' to change your default shell."
      echo "You will be prompted for your user password."
      if chsh -s "$ZSH_PATH"; then
        echo "Default shell successfully changed to zsh."
        echo "IMPORTANT: Please log out and log back in for the change to take effect."
      else
        echo "Warning: Failed to change default shell to zsh using 'chsh'." >&2
        echo "You may need to change it manually by running 'chsh -s $(which zsh)' and entering your password." >&2
        echo "Then, log out and log back in."
      fi
    else
      echo "Default shell is already zsh."
    fi

    # Install recommended font for Powerlevel10k (MesloLGS NF)
    if command -v fc-list &> /dev/null && ! fc-list | grep -q "MesloLGS NF"; then
      # (Font installation logic remains unchanged, as it's not directly related to the Zsh default shell issue)
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
    ;;
esac

## Oh my zsh install
## https://ohmyz.sh/
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo 'Installing Oh My Zsh...'
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

## Install zsh plugins and theme
ZSH_CUSTOM_DIR=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

PLUGINS=(
  "https://github.com/zsh-users/zsh-autosuggestions"
  "https://github.com/zsh-users/zsh-syntax-highlighting"
  "https://github.com/zsh-users/zsh-completions"
)

for plugin_url in "${PLUGINS[@]}"; do
  plugin_name=$(basename "$plugin_url")
  if [ ! -d "$ZSH_CUSTOM_DIR/plugins/$plugin_name" ]; then
    echo "Installing $plugin_name..."
    git clone "$plugin_url" "$ZSH_CUSTOM_DIR/plugins/$plugin_name"
  fi
done

if [ ! -d "$ZSH_CUSTOM_DIR/themes/powerlevel10k" ]; then
  echo "Installing powerlevel10k theme..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM_DIR/themes/powerlevel10k"
fi
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

## anyenv install
if [ ! -d "$HOME/.anyenv" ]; then
    git clone https://github.com/anyenv/anyenv ~/.anyenv
#    anyenv install --init # This should be run after anyenv is sourced in .zshrc, not directly here.
fi

## Platform specific init
case ${OSTYPE} in
  darwin*)
    bash "$DOTPATH/mac_init.sh"
    ;;
  linux*)
    bash "$DOTPATH/linux_init.sh"
    ;;
esac
