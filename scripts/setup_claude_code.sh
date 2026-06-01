#!/bin/bash

# Claude Code (Anthropic CLI) setup
# https://claude.ai/code

set -e

if ! command -v npm &> /dev/null; then
  echo "Error: npm is required. Install Node.js first."
  echo "  macOS: brew install node  (or via anyenv/asdf)"
  echo "  Linux: bash ~/dotfiles/scripts/setup_node.sh"
  exit 1
fi

echo "Installing Claude Code..."

if command -v claude &> /dev/null; then
  echo "Claude Code is already installed: $(claude --version 2>/dev/null || echo 'unknown version')"
  echo "Updating to latest..."
  npm update -g @anthropic-ai/claude-code
else
  npm install -g @anthropic-ai/claude-code
fi

echo ""
echo "Claude Code installed: $(claude --version 2>/dev/null || echo 'check PATH')"
echo ""
echo "Config files are managed via dotfiles:"
echo "  ~/.claude/settings.json  -> $HOME/dotfiles/claude/settings.json"
echo "  ~/.claude/CLAUDE.md      -> $HOME/dotfiles/claude/CLAUDE.md"
echo ""
echo "Login: claude login"
