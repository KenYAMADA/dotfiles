#!/bin/bash
#
# macOS-specific installer for dotfiles
# Command to execute:
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/kenyamada/dotfiles/main/install_mac.sh)"
#

# Exit the script if an error occurs
set -e

# --- Configuration ---
REPO_URL="https://github.com/kenyamada/dotfiles.git"
DOTPATH="$HOME/dotfiles"

# --- Execution ---

echo "🍎 macOS Dotfiles Installer"
echo "=========================="

# 1. Check for and install the prerequisite git command
if ! command -v git &> /dev/null; then
  echo "Git is not installed. Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "Please complete the Xcode Command Line Tools installation and run this script again."
  exit 1
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
chmod +x mac_init.sh
chmod +x scripts/*.sh
./setup.sh

echo ""
echo "✅ macOS setup complete! Please restart your shell to apply the changes."
echo "💡 Run 'p10k configure' to customize your Powerlevel10k theme."
