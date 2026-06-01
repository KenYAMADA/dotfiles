#!/bin/bash

# Android SDK Command-Line Tools setup
# Installs: sdkmanager, avdmanager, adb, fastboot
# https://developer.android.com/studio#command-tools

set -e

if [ "$(uname)" != "Darwin" ]; then
  echo "Error: This script is for macOS only."
  exit 1
fi

if ! command -v brew &> /dev/null; then
  echo "Error: Homebrew is required. Install it first."
  exit 1
fi

echo "Installing Android command-line tools..."

# android-commandlinetools: sdkmanager, avdmanager, etc.
if ! brew list --cask android-commandlinetools &> /dev/null; then
  brew install --cask android-commandlinetools
  echo "android-commandlinetools installed."
else
  echo "android-commandlinetools is already installed."
fi

# android-platform-tools: adb, fastboot
if ! brew list --cask android-platform-tools &> /dev/null; then
  brew install --cask android-platform-tools
  echo "android-platform-tools installed."
else
  echo "android-platform-tools is already installed."
fi

# Determine ANDROID_HOME from Homebrew if not set by Android Studio
CMDLINE_TOOLS_PATH="$(brew --prefix)/share/android-commandlinetools"
ANDROID_HOME_BREW="$HOME/Library/Android/sdk"

# Use Android Studio SDK path if it exists, otherwise use a standalone location
if [ ! -d "$ANDROID_HOME_BREW" ]; then
  ANDROID_HOME_BREW="$HOME/.android/sdk"
  mkdir -p "$ANDROID_HOME_BREW/cmdline-tools"
fi

export ANDROID_HOME="$ANDROID_HOME_BREW"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$CMDLINE_TOOLS_PATH/bin:$ANDROID_HOME/platform-tools:$PATH"

echo ""
echo "Installing essential SDK components via sdkmanager..."
yes | sdkmanager --sdk_root="$ANDROID_HOME" --licenses > /dev/null 2>&1 || true
sdkmanager --sdk_root="$ANDROID_HOME" \
  "platform-tools" \
  "build-tools;34.0.0" \
  "platforms;android-34"

echo ""
echo "Android SDK setup complete."
echo ""
echo "ANDROID_HOME: $ANDROID_HOME"
echo "adb version: $(adb version 2>/dev/null | head -1 || echo 'not found in PATH yet')"
echo ""
echo "Add the following to your shell (already in .zshenv if using this dotfiles):"
echo "  export ANDROID_HOME=\$HOME/Library/Android/sdk"
echo "  export PATH=\$ANDROID_HOME/platform-tools:\$PATH"
