#!/bin/bash

# Editor Font Configuration Script
# This script applies font settings to VSCode, Cursor, Windsurf, and terminal applications

set -e

echo "🎨 Setting up editor fonts..."

# Function to apply VSCode settings
apply_vscode_settings() {
    echo "Applying VSCode font settings..."
    
    # VSCode settings directory
    VSCODE_DIR="$HOME/Library/Application Support/Code/User"
    
    if [ -d "$VSCODE_DIR" ]; then
        # Backup existing settings
        if [ -f "$VSCODE_DIR/settings.json" ]; then
            cp "$VSCODE_DIR/settings.json" "$VSCODE_DIR/settings.json.backup"
            echo "Backed up existing VSCode settings"
        fi
        
        # Merge font settings with existing settings
        if [ -f "$VSCODE_DIR/settings.json" ]; then
            # Use jq to merge settings if available
            if command -v jq &> /dev/null; then
                echo "Merging VSCode settings using jq..."
                jq -s '.[0] * .[1]' "$VSCODE_DIR/settings.json" "$HOME/dotfiles/scripts/vscode_settings.json" > "$VSCODE_DIR/settings.json.tmp"
                mv "$VSCODE_DIR/settings.json.tmp" "$VSCODE_DIR/settings.json"
            else
                echo "jq not found, creating new settings file..."
                cp "$HOME/dotfiles/scripts/vscode_settings.json" "$VSCODE_DIR/settings.json"
            fi
        else
            # No existing settings, copy new ones
            cp "$HOME/dotfiles/scripts/vscode_settings.json" "$VSCODE_DIR/settings.json"
        fi
        echo "✅ VSCode settings applied"
    else
        echo "⚠️  VSCode not found, skipping configuration"
    fi
}

# Function to apply Cursor settings
apply_cursor_settings() {
    echo "Applying Cursor font settings..."
    
    # Cursor settings directory
    CURSOR_DIR="$HOME/Library/Application Support/Cursor/User"
    
    if [ -d "$CURSOR_DIR" ]; then
        # Backup existing settings
        if [ -f "$CURSOR_DIR/settings.json" ]; then
            cp "$CURSOR_DIR/settings.json" "$CURSOR_DIR/settings.json.backup"
            echo "Backed up existing Cursor settings"
        fi
        
        # Merge font settings with existing settings
        if [ -f "$CURSOR_DIR/settings.json" ]; then
            # Use jq to merge settings if available
            if command -v jq &> /dev/null; then
                echo "Merging Cursor settings using jq..."
                jq -s '.[0] * .[1]' "$CURSOR_DIR/settings.json" "$HOME/dotfiles/scripts/cursor_settings.json" > "$CURSOR_DIR/settings.json.tmp"
                mv "$CURSOR_DIR/settings.json.tmp" "$CURSOR_DIR/settings.json"
            else
                echo "jq not found, creating new settings file..."
                cp "$HOME/dotfiles/scripts/cursor_settings.json" "$CURSOR_DIR/settings.json"
            fi
        else
            # No existing settings, copy new ones
            cp "$HOME/dotfiles/scripts/cursor_settings.json" "$CURSOR_DIR/settings.json"
        fi
        echo "✅ Cursor settings applied"
    else
        echo "⚠️  Cursor not found, skipping configuration"
    fi
}

# Function to apply Windsurf settings
apply_windsurf_settings() {
    echo "Applying Windsurf font settings..."
    
    # Windsurf settings directory
    WINDSURF_DIR="$HOME/Library/Application Support/Windsurf/User"
    
    if [ -d "$WINDSURF_DIR" ]; then
        # Backup existing settings
        if [ -f "$WINDSURF_DIR/settings.json" ]; then
            cp "$WINDSURF_DIR/settings.json" "$WINDSURF_DIR/settings.json.backup"
            echo "Backed up existing Windsurf settings"
        fi
        
        # Merge font settings with existing settings
        if [ -f "$WINDSURF_DIR/settings.json" ]; then
            # Use jq to merge settings if available
            if command -v jq &> /dev/null; then
                echo "Merging Windsurf settings using jq..."
                jq -s '.[0] * .[1]' "$WINDSURF_DIR/settings.json" "$HOME/dotfiles/scripts/windsurf_settings.json" > "$WINDSURF_DIR/settings.json.tmp"
                mv "$WINDSURF_DIR/settings.json.tmp" "$WINDSURF_DIR/settings.json"
            else
                echo "jq not found, creating new settings file..."
                cp "$HOME/dotfiles/scripts/windsurf_settings.json" "$WINDSURF_DIR/settings.json"
            fi
        else
            # No existing settings, copy new ones
            cp "$HOME/dotfiles/scripts/windsurf_settings.json" "$WINDSURF_DIR/settings.json"
        fi
        echo "✅ Windsurf settings applied"
    else
        echo "⚠️  Windsurf not found, skipping configuration"
    fi
}

# Function to install required fonts
install_fonts() {
    echo "Installing required fonts..."
    
    if command -v brew &> /dev/null; then
        # Install Nerd Fonts
        brew install --cask font-meslo-lg-nerd-font || true
        brew install --cask font-hack-nerd-font || true
        brew install --cask font-hackgen || true
        brew install --cask font-hackgen-nerd || true
        
        echo "✅ Fonts installed"
    else
        echo "⚠️  Homebrew not found. Please install fonts manually:"
        echo "   - MesloLGS Nerd Font"
        echo "   - Hack Nerd Font"
        echo "   - HackGen"
        echo "   - HackGenNerd"
    fi
}

# Function to create symlinks for easy access
create_symlinks() {
    echo "Creating symlinks for easy access..."
    
    # Create symlinks in home directory
    ln -sf "$HOME/dotfiles/scripts/vscode_settings.json" "$HOME/.vscode_settings.json"
    ln -sf "$HOME/dotfiles/scripts/cursor_settings.json" "$HOME/.cursor_settings.json"
    ln -sf "$HOME/dotfiles/scripts/windsurf_settings.json" "$HOME/.windsurf_settings.json"
    
    echo "✅ Symlinks created"
}

# Main execution
if [[ "$(uname)" == "Darwin" ]]; then
    install_fonts
    
    # Use the safe merge script for editor settings
    echo "Using safe merge for editor settings..."
    bash "$HOME/dotfiles/scripts/merge_editor_settings.sh"
    
    create_symlinks
    
    echo ""
    echo "🎉 Editor font setup completed!"
    echo ""
    echo "📝 Next steps:"
    echo "   1. Restart VSCode, Cursor, and Windsurf to apply font changes"
    echo "   2. Run './scripts/setup_terminal_fonts.sh' to configure terminal fonts"
    echo "   3. Run './scripts/setup_iterm2_profile.sh' to configure iTerm2"
    echo ""
    echo "🔤 Font priority order:"
    echo "   1. MesloLGS Nerd Font (Powerlevel10k recommended)"
    echo "   2. HackGenNerd"
    echo "   3. Hack Nerd Font"
    echo "   4. Fira Code"
    echo "   5. Monaco (macOS default)"
    echo "   6. Menlo (macOS default)"
    echo "   7. Ubuntu Mono"
    echo "   8. monospace (fallback)"
    echo ""
    echo "💾 Your existing settings have been backed up with timestamps"
    echo "🔄 To restore original settings, copy the .backup files back"
else
    echo "This script is for macOS only."
    exit 1
fi
