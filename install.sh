#!/bin/bash
#
# This script clones the dotfiles repository and starts the setup.
# Command to execute:
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/kenyamada/dotfiles/main/install.sh)"
#

# Exit the script if an error occurs
set -e

# --- Configuration (change according to your environment) ---
# GitHub username and repository name
REPO_URL="https://github.com/kenyamada/dotfiles.git"
# Location to clone dotfiles
DOTPATH="$HOME/dotfiles"

# --- Execution ---

# 1. Check for and install the prerequisite git command
if ! command -v git &> /dev/null; then
  echo "Git is not installed. Attempting to install..."
  # Determine OS type
  case "$(uname -s)" in
    'Darwin')
      # For macOS, prompt to install Xcode Command Line Tools
      # This will install git (user interaction required)
      echo "Starting installation of Xcode Command Line Tools..."
      xcode-select --install
      ;;
    'Linux')
      # For Debian/Ubuntu based Linux
      if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y git
      # For RedHat/CentOS based Linux
      elif command -v yum &> /dev/null; then
        sudo yum install -y git
      else
        echo "'apt-get' or 'yum' not found. Please install Git manually."
        exit 1
      fi
      ;;
    *)
      echo "Unsupported OS: $(uname -s). Please install Git manually."
      exit 1
      ;;
  esac
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
# Grant execute permission to setup.sh
chmod +x setup.sh
./setup.sh

echo ""
echo "Setup complete! Please restart your shell to apply the changes."
