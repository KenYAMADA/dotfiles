#!/bin/bash

# Antigravity CLI setup (Google Antigravity agent platform)
# https://antigravity.google/product/antigravity-2

set -e

if [ "$(uname)" != "Darwin" ]; then
  echo "Error: Antigravity is currently macOS only."
  exit 1
fi

if ! command -v brew &> /dev/null; then
  echo "Error: Homebrew is required."
  exit 1
fi

echo "Installing Antigravity..."

if brew list --cask antigravity &> /dev/null; then
  echo "Antigravity is already installed. Upgrading..."
  brew upgrade --cask antigravity || true
else
  brew install --cask antigravity
fi

# CLI is provided as symlinks inside ~/.antigravity/antigravity/bin/
# These are created by the app on first launch. Verify they exist.
AGY_BIN="$HOME/.antigravity/antigravity/bin"
if [ -d "$AGY_BIN" ]; then
  echo "Antigravity CLI available at $AGY_BIN"
  echo "  antigravity -> $(readlink "$AGY_BIN/antigravity" 2>/dev/null || echo 'not linked yet')"
else
  echo "Note: Launch Antigravity.app once to initialize CLI symlinks in ~/.antigravity/antigravity/bin/"
fi

echo ""
echo "Antigravity installation complete."
echo "PATH entry (~/.antigravity/antigravity/bin) is already in .zshenv."
