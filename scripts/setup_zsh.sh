#!/bin/bash

# Oh My Zsh Setup Script

set -e

echo "Starting Oh My Zsh setup..."

if ! command -v zsh &> /dev/null; then
    echo "Error: zsh is not installed. Please install zsh first."
    exit 1
fi

# Oh My Zsh install dir (XDG: ~/.local/share/oh-my-zsh)
OMZ_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/oh-my-zsh"

if [ ! -d "$OMZ_DIR" ]; then
    echo "Installing Oh My Zsh to $OMZ_DIR ..."
    ZSH="$OMZ_DIR" sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "Oh My Zsh installed successfully"
else
    echo "Oh My Zsh is already installed at $OMZ_DIR"
fi

ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$OMZ_DIR/custom}"

PLUGINS=(
  "https://github.com/zsh-users/zsh-autosuggestions"
  "https://github.com/zsh-users/zsh-syntax-highlighting"
  "https://github.com/zsh-users/zsh-completions"
)

for plugin_url in "${PLUGINS[@]}"; do
  plugin_name=$(basename "$plugin_url")
  if [ ! -d "$ZSH_CUSTOM_DIR/plugins/$plugin_name" ]; then
    echo "Installing plugin: $plugin_name ..."
    git clone "$plugin_url" "$ZSH_CUSTOM_DIR/plugins/$plugin_name" && echo "$plugin_name installed" || echo "Failed to install $plugin_name"
  else
    echo "Plugin $plugin_name is already installed"
  fi
done

# Powerlevel10k: macOS only (Linux uses Starship)
case ${OSTYPE} in
  darwin*)
    if [ ! -d "$ZSH_CUSTOM_DIR/themes/powerlevel10k" ]; then
      echo "Installing Powerlevel10k theme..."
      git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM_DIR/themes/powerlevel10k" \
        && echo "Powerlevel10k installed" || echo "Failed to install Powerlevel10k"
    else
      echo "Powerlevel10k theme is already installed"
    fi
    ;;
esac

echo "Oh My Zsh setup completed!"
echo ""
case ${OSTYPE} in
  darwin*)
    echo "Next: run 'p10k configure' to set up your Powerlevel10k theme"
    echo "      or copy existing config: mv ~/.p10k.zsh ~/.config/p10k.zsh"
    ;;
  linux*)
    echo "Next: restart your shell to activate Starship prompt"
    ;;
esac
echo ""
