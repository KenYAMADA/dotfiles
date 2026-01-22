#!/bin/bash

if [ "$(uname)" != "Linux" ] ; then
	echo "Not Linux!"
	exit 1
fi

# --- Determine CPU architecture ---
ARCH_TYPE=""
case $(uname -m) in
  x86_64)
    ARCH_TYPE="amd64"
    ;;
  aarch64)
    ARCH_TYPE="arm64"
    ;;
  *)
    echo "Unsupported CPU architecture: $(uname -m)"
    # Set a compatible one or exit here
    ARCH_TYPE="amd64" 
    ;;
esac
echo "Detected CPU architecture as ${ARCH_TYPE}."

## Google Cloud related tools (gcloud, cloud_sql_proxy) are now managed by a separate script.
## To install them, run:
## bash ~/dotfiles/scripts/setup_gcloud.sh

## Starship prompt installation
if ! command -v starship > /dev/null 2>&1; then
    echo "Installing Starship prompt..."

    # Try official installer first (most reliable)
    if curl -fsSL https://starship.rs/install.sh | sh -s -- --yes; then
        echo "Starship installed via official installer."
    else
        echo "Official installer failed, trying package manager..."

        # Fallback to package managers
        if command -v apt-get &> /dev/null; then
            # For Ubuntu/Debian - need to add repo or use snap
            if command -v snap &> /dev/null; then
                sudo snap install starship
            else
                echo "Manual installation required. Please visit: https://starship.rs/guide/#step-1-install-starship"
            fi
        elif command -v dnf &> /dev/null; then
            sudo dnf install starship
        elif command -v pacman &> /dev/null; then
            sudo pacman -S starship
        else
            echo "Package manager not supported. Manual installation required."
            echo "Please visit: https://starship.rs/guide/#step-1-install-starship"
        fi
    fi
else
    echo "Starship is already installed."
fi

# Copy Starship configuration
if [ -f "$HOME/dotfiles/starship.toml" ]; then
    mkdir -p "$HOME/.config"
    cp "$HOME/dotfiles/starship.toml" "$HOME/.config/starship.toml"
    echo "Starship configuration copied."
fi

## vim plugin
if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

# anyenv plugins are typically initialized by 'anyenv install --init' in setup.sh.
# If you need to install additional specific plugins, uncomment and add them here.
# anyenv install rbenv
# anyenv install pyenv
# anyenv install nodenv
# anyenv install goenv
# anyenv install jenv

# anyenv update plugins
mkdir -p $(anyenv root)/plugins
if [ ! -d "$(anyenv root)/plugins/anyenv-update" ]; then
    echo "Cloning anyenv-update plugin..."
    git clone https://github.com/znz/anyenv-update.git $(anyenv root)/plugins/anyenv-update
else
    echo "anyenv-update plugin already exists. Skipping clone."
fi

# GitHub CLI config
mkdir -p $HOME/.config/gh && ln -snf $HOME/dotfiles/gh/config.yml $HOME/.config/gh/config.yml

# --- Install GUI Applications (Optional) ---
# Install GUI apps only if $DISPLAY variable exists and user wants them
if [ -n "$DISPLAY" ] && command -v apt-get &> /dev/null; then
    echo "GUI environment detected."
    echo "GUI applications (Zoom, Discord) are available but not installed by default."
    echo "To install them manually, run:"
    echo "  # Install Zoom:"
    echo "  curl -L 'https://zoom.us/client/latest/zoom_${ARCH_TYPE}.deb' -o /tmp/zoom.deb && sudo apt-get install -y /tmp/zoom.deb && rm -f /tmp/zoom.deb"
    echo "  # Install Discord (amd64 only):"
    echo "  curl -L 'https://discord.com/api/download?platform=linux&format=deb' -o /tmp/discord.deb && sudo apt-get install -y /tmp/discord.deb && rm -f /tmp/discord.deb"
else
    echo "No GUI environment or not a Debian-based system. Skipping GUI application installation."
fi


echo "Linux init script finished."
