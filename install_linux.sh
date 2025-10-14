#!/bin/bash
#
# Linux-specific installer for dotfiles (bash-focused)
# Command to execute:
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/kenyamada/dotfiles/main/install_linux.sh)"
#

# Exit the script if an error occurs
set -e

# --- Configuration ---
REPO_URL="https://github.com/kenyamada/dotfiles.git"
DOTPATH="$HOME/dotfiles"

# --- Execution ---

echo "🐧 Linux Dotfiles Installer (Bash-focused)"
echo "========================================"

# 1. Check for and install the prerequisite git command
if ! command -v git &> /dev/null; then
  echo "Git is not installed. Attempting to install..."
  # Determine package manager
  if command -v apt-get &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y git
  elif command -v dnf &> /dev/null; then
    sudo dnf install -y git
  elif command -v yum &> /dev/null; then
    sudo yum install -y git
  elif command -v pacman &> /dev/null; then
    sudo pacman -S --noconfirm git
  else
    echo "No supported package manager found. Please install Git manually."
    exit 1
  fi
fi

# 2. Clone the dotfiles repository
if [ -d "$DOTPATH" ]; then
  echo "$DOTPATH already exists. Fetching the latest content..."
  cd "$DOTPATH"
  git pull
  cd "$HOME"
else
  echo "Cloning dotfiles from $REPO_URL..."
  git clone "$REPO_URL" "$DOTPATH"
fi

# 3. Execute the main setup script
echo "Moving to $DOTPATH to start the main setup..."
cd "$DOTPATH"
# Grant execute permission to all scripts
chmod +x setup.sh
chmod +x linux_init.sh
chmod +x scripts/*.sh
./setup.sh

echo ""
echo "✅ Linux setup complete! Please restart your shell to apply the changes."
echo "💡 Your shell is now configured with bash and essential tools."
