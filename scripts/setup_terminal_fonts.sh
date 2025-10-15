#!/bin/bash

# macOS Terminal and iTerm2 Font Configuration Script
# This script configures fonts for Terminal, iTerm2, and other terminal applications

set -e

echo "🔤 Setting up terminal fonts..."

# Function to configure macOS Terminal font
configure_terminal_font() {
    echo "Configuring macOS Terminal font..."
    
    # Set Terminal font to MesloLGS Nerd Font
    defaults write com.apple.Terminal "NSFont" -string "MesloLGS Nerd Font"
    defaults write com.apple.Terminal "NSFontSize" -float 14.0
    
    # Alternative fonts if MesloLGS is not available
    if ! fc-list | grep -q "MesloLGS Nerd Font"; then
        echo "MesloLGS Nerd Font not found, trying alternatives..."
        if fc-list | grep -q "HackGenNerd"; then
            defaults write com.apple.Terminal "NSFont" -string "HackGenNerd"
        elif fc-list | grep -q "Hack Nerd Font"; then
            defaults write com.apple.Terminal "NSFont" -string "Hack Nerd Font"
        else
            defaults write com.apple.Terminal "NSFont" -string "Monaco"
        fi
    fi
    
    echo "✅ Terminal font configured"
}

# Function to configure iTerm2 font
configure_iterm2_font() {
    echo "Configuring iTerm2 font..."
    
    # iTerm2 font configuration
    if [ -f "$HOME/Library/Preferences/com.googlecode.iterm2.plist" ]; then
        # Set font family
        defaults write com.googlecode.iterm2 "Normal Font" -string "MesloLGS Nerd Font"
        defaults write com.googlecode.iterm2 "Non Ascii Font" -string "MesloLGS Nerd Font"
        
        # Set font size
        defaults write com.googlecode.iterm2 "Font Size" -float 14.0
        
        echo "✅ iTerm2 font configured"
    else
        echo "⚠️  iTerm2 not found, skipping configuration"
    fi
}

# Function to install fonts if not present
install_fonts() {
    echo "Checking and installing fonts..."
    
    # Check if fonts are installed
    if ! fc-list | grep -q "MesloLGS Nerd Font"; then
        echo "Installing MesloLGS Nerd Font..."
        if command -v brew &> /dev/null; then
            brew install --cask font-meslo-lg-nerd-font
        else
            echo "Homebrew not found. Please install fonts manually."
        fi
    fi
    
    if ! fc-list | grep -q "HackGenNerd"; then
        echo "Installing HackGenNerd font..."
        if command -v brew &> /dev/null; then
            brew install --cask font-hackgen-nerd
        fi
    fi
}

# Main execution
if [[ "$(uname)" == "Darwin" ]]; then
    install_fonts
    configure_terminal_font
    configure_iterm2_font
    
    echo "🎉 Terminal font setup completed!"
    echo "📝 Please restart Terminal/iTerm2 to apply font changes."
else
    echo "This script is for macOS only."
    exit 1
fi

