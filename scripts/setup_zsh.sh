#!/bin/bash

# Oh My Zsh Setup Script
# This script handles the installation and configuration of Oh My Zsh and related plugins

set -e  # Exit on any error

echo "🚀 Starting Oh My Zsh setup..."

# Check if zsh is available
if ! command -v zsh &> /dev/null; then
    echo "❌ Error: zsh is not installed. Please install zsh first."
    exit 1
fi

## Oh My Zsh installation
## https://ohmyz.sh/
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "📦 Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "✅ Oh My Zsh installed successfully"
else
    echo "✅ Oh My Zsh is already installed"
fi

## Install zsh plugins and theme
echo "🔌 Setting up Oh My Zsh plugins and themes..."
ZSH_CUSTOM_DIR=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

# Define plugins to install
PLUGINS=(
  "https://github.com/zsh-users/zsh-autosuggestions"
  "https://github.com/zsh-users/zsh-syntax-highlighting"
  "https://github.com/zsh-users/zsh-completions"
)

# Install plugins
for plugin_url in "${PLUGINS[@]}"; do
  plugin_name=$(basename "$plugin_url")
  if [ ! -d "$ZSH_CUSTOM_DIR/plugins/$plugin_name" ]; then
    echo "📦 Installing plugin: $plugin_name..."
    if git clone "$plugin_url" "$ZSH_CUSTOM_DIR/plugins/$plugin_name"; then
      echo "✅ $plugin_name installed successfully"
    else
      echo "❌ Failed to install $plugin_name"
    fi
  else
    echo "✅ Plugin $plugin_name is already installed"
  fi
done

# Install Powerlevel10k theme
if [ ! -d "$ZSH_CUSTOM_DIR/themes/powerlevel10k" ]; then
  echo "🎨 Installing Powerlevel10k theme..."
  if git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM_DIR/themes/powerlevel10k"; then
    echo "✅ Powerlevel10k theme installed successfully"
  else
    echo "❌ Failed to install Powerlevel10k theme"
  fi
else
  echo "✅ Powerlevel10k theme is already installed"
fi

echo "🎉 Oh My Zsh setup completed!"
echo ""
echo "📝 Next steps:"
echo "  1. Restart your terminal or run 'source ~/.zshrc' to apply changes"
echo "  2. Run 'p10k configure' to customize your Powerlevel10k theme"
echo ""