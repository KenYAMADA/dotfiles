#!/bin/bash

DOTPATH=$HOME/dotfiles
# OS-specific dotfiles
case ${OSTYPE} in
  darwin*)
    DOT_FILES=(.bin .zshrc .zshenv .vimrc)
    ;;
  linux*)
    DOT_FILES=(.bin .bashrc .vimrc)
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
    echo "Linux environment detected. Setting up bash-focused environment..."

    # Check if bash is available (should be default)
    if ! command -v bash &> /dev/null; then
      echo "Error: bash is not available. This installer requires bash." >&2
      exit 1
    fi

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

    echo "Bash-focused Linux setup complete."
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
    ## Bash setup for Linux
    echo "Setting up bash environment..."
    # Create bash configuration
    if [ ! -f "$HOME/.bashrc" ] || [ ! -L "$HOME/.bashrc" ]; then
        echo "Creating bash configuration..."
        # Create a basic .bashrc if it doesn't exist
        touch "$HOME/.bashrc"
    fi
    ;;
esac
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
fi

# Ensure anyenv is available for the current script execution
if [ -d "$HOME/.anyenv" ]; then
    export PATH="$HOME/.anyenv/bin:$PATH"
    if command -v anyenv &> /dev/null; then
        eval "$(anyenv init -)"
        # Initialize anyenv definitions (e.g., rbenv, pyenv)
        if [ ! -d "$(anyenv root)/plugins/anyenv-install" ]; then # Check if anyenv-install plugin is installed
            echo "Initializing anyenv definitions..."
            anyenv install --init
        fi
        # Point to the correct definition root for the anyenv-install plugin
        export ANYENV_DEFINITION_ROOT="$(anyenv root)/plugins/anyenv-install"
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
