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

## vim plugin
if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

## anyenv setup: install plugins
anyenv install rbenv
anyenv install pyenv
anyenv install nodenv
anyenv install goenv
anyenv install jenv

# anyenv update plugins
mkdir -p $(anyenv root)/plugins
git clone https://github.com/znz/anyenv-update.git $(anyenv root)/plugins/anyenv-update

# GitHub CLI config
mkdir -p $HOME/.config/gh && ln -snf $HOME/dotfiles/gh/config.yml $HOME/.config/gh/config.yml

## Install packages via other methods
# ------------------------------------
# Install Heroku CLI
curl https://cli-assets.heroku.com/install.sh | sh


# --- Install GUI Applications ---
# Install GUI apps only if $DISPLAY variable exists
if [ -n "$DISPLAY" ] && command -v apt-get &> /dev/null; then
    echo "GUI environment detected. Installing GUI applications..."

    # Install Zoom
    if ! command -v zoom &> /dev/null; then
        echo "Installing Zoom..."
        # Use curl for consistency with other scripts
        curl -L "https://zoom.us/client/latest/zoom_${ARCH_TYPE}.deb" -o /tmp/zoom.deb
        sudo apt-get install -y /tmp/zoom.deb
        rm -f /tmp/zoom.deb
    fi

    # Install Discord (Note: Discord may not officially support ARM64)
    if [ "$ARCH_TYPE" = "amd64" ]; then
        if ! command -v discord &> /dev/null; then
            echo "Installing Discord..."
            curl -L "https://discord.com/api/download?platform=linux&format=deb" -o /tmp/discord.deb
            sudo apt-get install -y /tmp/discord.deb
            rm -f /tmp/discord.deb
        fi
    else
        echo "Skipping Discord installation as it is not supported on non-amd64 architectures."
    fi
else
    echo "No GUI environment or not a Debian-based system. Skipping GUI application installation."
fi


echo "Linux init script finished."
