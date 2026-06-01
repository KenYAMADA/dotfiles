#!/bin/bash

# OpenAI Codex CLI setup
# https://github.com/openai/codex

set -e

if ! command -v brew &> /dev/null; then
  echo "Error: Homebrew is required."
  exit 1
fi

echo "Installing Codex CLI..."

if brew list --cask codex &> /dev/null; then
  echo "Codex is already installed. Upgrading..."
  brew upgrade --cask codex || true
else
  brew install --cask codex
fi

echo ""
echo "Codex CLI installed: $(codex --version 2>/dev/null || echo 'check PATH')"
echo ""
echo "Login: codex login"
