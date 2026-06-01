#!/bin/bash

# Cursor (AI code editor) setup
# https://www.cursor.com/

set -e

if [ "$(uname)" != "Darwin" ]; then
  echo "Error: Cursor is currently macOS only."
  exit 1
fi

if ! command -v brew &> /dev/null; then
  echo "Error: Homebrew is required."
  exit 1
fi

echo "Installing Cursor..."

if brew list --cask cursor &> /dev/null; then
  echo "Cursor is already installed. Upgrading..."
  brew upgrade --cask cursor || true
else
  brew install --cask cursor
fi

echo ""
echo "Cursor installation complete."
echo "Font settings: bash ~/dotfiles/scripts/setup_cursor_fonts.sh"
