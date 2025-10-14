#!/bin/bash

# Script to install Node.js using nvm (Node Version Manager)
# This keeps Node installation separate from system packages

set -e

# Install nvm if not already present
if [ -s "$HOME/.nvm/nvm.sh" ]; then
  echo "nvm already installed."
else
  echo "Installing nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

# Load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install and use latest LTS Node.js
if command -v nvm > /dev/null; then
  nvm install --lts
  nvm use --default --lts
fi

