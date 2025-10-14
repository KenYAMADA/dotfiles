#!/bin/bash
#
# Universal installer for dotfiles - detects OS and runs appropriate installer
# Command to execute:
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/kenyamada/dotfiles/main/install.sh)"
#

# Exit the script if an error occurs
set -e

# --- Configuration ---
REPO_URL="https://github.com/kenyamada/dotfiles.git"
DOTPATH="$HOME/dotfiles"

# --- Execution ---

echo "🚀 Universal Dotfiles Installer"
echo "=============================="

# 1. Check for and install the prerequisite git command
if ! command -v git &> /dev/null; then
  echo "Git is not installed. Attempting to install..."
  # Determine OS type
  case "$(uname -s)" in
    'Darwin')
      # For macOS, prompt to install Xcode Command Line Tools
      echo "Starting installation of Xcode Command Line Tools..."
      xcode-select --install
      echo "Please complete the Xcode Command Line Tools installation and run this script again."
      exit 1
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

# 3. Detect OS and run appropriate installer
echo "Detecting operating system..."
case "$(uname -s)" in
  'Darwin')
    echo "🍎 macOS detected. Running macOS installer..."
    cd "$DOTPATH"
    chmod +x install_mac.sh
    ./install_mac.sh
    ;;
  'Linux')
    echo "🐧 Linux detected. Running Linux installer..."
    cd "$DOTPATH"
    chmod +x install_linux.sh
    ./install_linux.sh
    ;;
  *)
    echo "❌ Unsupported operating system: $(uname -s)"
    echo "Please use the appropriate installer for your system:"
    echo "  macOS: install_mac.sh"
    echo "  Linux: install_linux.sh"
    exit 1
    ;;
esac
