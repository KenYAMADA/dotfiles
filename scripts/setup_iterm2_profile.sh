#!/bin/bash

# iTerm2 Profile Configuration Script
# This script creates a comprehensive iTerm2 profile with font settings

set -e

echo "🎨 Setting up iTerm2 profile..."

# Function to create iTerm2 profile
create_iterm2_profile() {
    echo "Creating iTerm2 profile configuration..."
    
    # Create profile directory if it doesn't exist
    mkdir -p "$HOME/Library/Application Support/iTerm2/DynamicProfiles"
    
    # Create a comprehensive iTerm2 profile
    cat > "$HOME/Library/Application Support/iTerm2/DynamicProfiles/DotfilesProfile.json" << 'EOF'
{
  "Profiles": [
    {
      "Name": "Dotfiles Profile",
      "Guid": "DOTFILES-PROFILE-GUID",
      "Badge Text": "",
      "Badge Color": {
        "Red": 0.0,
        "Green": 0.0,
        "Blue": 0.0,
        "Alpha": 0.0
      },
      "Background Color": {
        "Red": 0.0,
        "Green": 0.0,
        "Blue": 0.0,
        "Alpha": 1.0
      },
      "Foreground Color": {
        "Red": 0.8,
        "Green": 0.8,
        "Blue": 0.8,
        "Alpha": 1.0
      },
      "Cursor Color": {
        "Red": 0.8,
        "Green": 0.8,
        "Blue": 0.8,
        "Alpha": 1.0
      },
      "Selection Color": {
        "Red": 0.3,
        "Green": 0.3,
        "Blue": 0.3,
        "Alpha": 1.0
      },
      "Font": "MesloLGS Nerd Font",
      "Font Size": 14,
      "Font Weight": 0,
      "Use Bold Font": false,
      "Use Bright Bold": true,
      "Use Italic Font": false,
      "Use Thin Strokes": false,
      "ASCII Anti Aliased": true,
      "Non-ASCII Anti Aliased": true,
      "Use Non-ASCII Font": true,
      "Non-ASCII Font": "MesloLGS Nerd Font",
      "Non-ASCII Font Size": 14,
      "Use Ligatures": true,
      "Horizontal Spacing": 1.0,
      "Vertical Spacing": 1.0,
      "Minimum Contrast": 0.0,
      "Cursor Type": 0,
      "Cursor Blink": true,
      "Cursor Text Color": {
        "Red": 0.0,
        "Green": 0.0,
        "Blue": 0.0,
        "Alpha": 1.0
      },
      "Use Cursor Guide": false,
      "Cursor Guide Color": {
        "Red": 0.5,
        "Green": 0.5,
        "Blue": 0.5,
        "Alpha": 0.25
      },
      "Blink Allowed": true,
      "Use Bold Color": true,
      "Use Bright Bold Color": true,
      "Use Dim Bold Color": false,
      "Use Italic Color": false,
      "Use Tab Color": false,
      "Tab Color": {
        "Red": 0.0,
        "Green": 0.0,
        "Blue": 0.0,
        "Alpha": 1.0
      },
      "Underline Color": {
        "Red": 0.0,
        "Green": 0.0,
        "Blue": 0.0,
        "Alpha": 1.0
      },
      "Underline Thickness": 1.0,
      "Strikethrough Color": {
        "Red": 0.0,
        "Green": 0.0,
        "Blue": 0.0,
        "Alpha": 1.0
      },
      "Strikethrough Thickness": 1.0,
      "URL Color": {
        "Red": 0.0,
        "Green": 0.0,
        "Blue": 1.0,
        "Alpha": 1.0
      },
      "Smart Cursor Color": true,
      "Minimum Contrast": 0.0,
      "Cursor Boost": 0.0,
      "Cursor Boost Limit": 0.0,
      "Use Separate Colors for Light and Dark Mode": false,
      "Sync Title": false,
      "Disable Window Resizing": false,
      "Only The Default BG Color Uses Transparency": false,
      "ASCII Ligatures": true,
      "Non-ASCII Ligatures": true,
      "Use Bright Bold": true,
      "Bold Color": {
        "Red": 1.0,
        "Green": 1.0,
        "Blue": 1.0,
        "Alpha": 1.0
      },
      "Bright Bold Color": {
        "Red": 1.0,
        "Green": 1.0,
        "Blue": 1.0,
        "Alpha": 1.0
      },
      "Dim Bold Color": {
        "Red": 0.5,
        "Green": 0.5,
        "Blue": 0.5,
        "Alpha": 1.0
      },
      "Italic Color": {
        "Red": 0.8,
        "Green": 0.8,
        "Blue": 0.8,
        "Alpha": 1.0
      },
      "Ansi 0 Color": {
        "Red": 0.0,
        "Green": 0.0,
        "Blue": 0.0,
        "Alpha": 1.0
      },
      "Ansi 1 Color": {
        "Red": 0.8,
        "Green": 0.0,
        "Blue": 0.0,
        "Alpha": 1.0
      },
      "Ansi 2 Color": {
        "Red": 0.0,
        "Green": 0.8,
        "Blue": 0.0,
        "Alpha": 1.0
      },
      "Ansi 3 Color": {
        "Red": 0.8,
        "Green": 0.8,
        "Blue": 0.0,
        "Alpha": 1.0
      },
      "Ansi 4 Color": {
        "Red": 0.0,
        "Green": 0.0,
        "Blue": 0.8,
        "Alpha": 1.0
      },
      "Ansi 5 Color": {
        "Red": 0.8,
        "Green": 0.0,
        "Blue": 0.8,
        "Alpha": 1.0
      },
      "Ansi 6 Color": {
        "Red": 0.0,
        "Green": 0.8,
        "Blue": 0.8,
        "Alpha": 1.0
      },
      "Ansi 7 Color": {
        "Red": 0.8,
        "Green": 0.8,
        "Blue": 0.8,
        "Alpha": 1.0
      },
      "Ansi 8 Color": {
        "Red": 0.4,
        "Green": 0.4,
        "Blue": 0.4,
        "Alpha": 1.0
      },
      "Ansi 9 Color": {
        "Red": 1.0,
        "Green": 0.0,
        "Blue": 0.0,
        "Alpha": 1.0
      },
      "Ansi 10 Color": {
        "Red": 0.0,
        "Green": 1.0,
        "Blue": 0.0,
        "Alpha": 1.0
      },
      "Ansi 11 Color": {
        "Red": 1.0,
        "Green": 1.0,
        "Blue": 0.0,
        "Alpha": 1.0
      },
      "Ansi 12 Color": {
        "Red": 0.0,
        "Green": 0.0,
        "Blue": 1.0,
        "Alpha": 1.0
      },
      "Ansi 13 Color": {
        "Red": 1.0,
        "Green": 0.0,
        "Blue": 1.0,
        "Alpha": 1.0
      },
      "Ansi 14 Color": {
        "Red": 0.0,
        "Green": 1.0,
        "Blue": 1.0,
        "Alpha": 1.0
      },
      "Ansi 15 Color": {
        "Red": 1.0,
        "Green": 1.0,
        "Blue": 1.0,
        "Alpha": 1.0
      }
    }
  ]
}
EOF

    echo "✅ iTerm2 profile created"
}

# Function to set default profile
set_default_profile() {
    echo "Setting default iTerm2 profile..."
    
    # Set the profile as default
    defaults write com.googlecode.iterm2 "Default Profile" -string "Dotfiles Profile"
    
    echo "✅ Default profile set"
}

# Main execution
if [[ "$(uname)" == "Darwin" ]]; then
    create_iterm2_profile
    set_default_profile
    
    echo "🎉 iTerm2 profile setup completed!"
    echo "📝 Please restart iTerm2 to apply the new profile."
else
    echo "This script is for macOS only."
    exit 1
fi

