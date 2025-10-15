#!/bin/bash

# VSCode Font Configuration Script
# This script configures fonts for VSCode only

set -e

echo "🔤 Setting up VSCode fonts..."

# Function to use fallback merge method (without jq)
use_fallback_merge() {
    local target_file="$1"
    local source_file="$2"
    local editor_name="$3"
    
    echo "Using fallback merge method for $editor_name..."
    echo "⚠️  This will create a new settings file with font configurations."
    echo "   Your existing settings will be backed up."
    echo ""
    
    # Simply copy the font settings file
    # This is safer than trying to merge without proper JSON tools
    cp "$source_file" "$target_file"
    echo "✅ $editor_name settings applied using fallback method"
    echo "   Please manually add any missing settings from your backup file if needed."
}

# Function to safely merge JSON settings
merge_json_settings() {
    local target_file="$1"
    local source_file="$2"
    local editor_name="$3"
    
    echo "Merging $editor_name settings..."
    
    # Check if target file exists
    if [ ! -f "$target_file" ]; then
        echo "No existing $editor_name settings found, copying new settings..."
        cp "$source_file" "$target_file"
        return 0
    fi
    
    # Backup existing settings
    cp "$target_file" "${target_file}.backup.$(date +%Y%m%d_%H%M%S)"
    echo "Backed up existing $editor_name settings"
    
    # Check if jq is available
    if ! command -v jq &> /dev/null; then
        echo "⚠️  jq not found. Attempting to install jq..."
        if command -v brew &> /dev/null; then
            echo "Installing jq via Homebrew..."
            brew install jq
            if ! command -v jq &> /dev/null; then
                echo "❌ Failed to install jq. Using fallback method..."
                use_fallback_merge "$target_file" "$source_file" "$editor_name"
                return $?
            fi
        else
            echo "❌ Homebrew not found. Using fallback method..."
            use_fallback_merge "$target_file" "$source_file" "$editor_name"
            return $?
        fi
    fi
    
    # Validate JSON files
    if ! jq empty "$target_file" 2>/dev/null; then
        echo "⚠️  Invalid JSON in existing $editor_name settings, creating new file..."
        cp "$source_file" "$target_file"
        return 0
    fi
    
    if ! jq empty "$source_file" 2>/dev/null; then
        echo "❌ Invalid JSON in source file for $editor_name"
        return 1
    fi
    
    # Merge settings (existing settings take precedence, then new font settings)
    echo "Merging $editor_name settings using jq..."
    jq -s '.[0] * .[1]' "$target_file" "$source_file" > "${target_file}.tmp"
    
    # Validate merged JSON
    if jq empty "${target_file}.tmp" 2>/dev/null; then
        mv "${target_file}.tmp" "$target_file"
        echo "✅ $editor_name settings merged successfully"
    else
        echo "❌ Merged JSON is invalid, keeping original settings"
        rm -f "${target_file}.tmp"
        return 1
    fi
}

# Function to apply VSCode settings
apply_vscode_settings() {
    local vscode_dir="$HOME/Library/Application Support/Code/User"
    local settings_file="$vscode_dir/settings.json"
    local source_file="$HOME/dotfiles/scripts/vscode_settings.json"
    
    if [ -d "$vscode_dir" ]; then
        merge_json_settings "$settings_file" "$source_file" "VSCode"
    else
        echo "⚠️  VSCode not found, skipping configuration"
        echo "Please install VSCode first, then run this script again."
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

# Main execution
if [[ "$(uname)" == "Darwin" ]]; then
    install_fonts
    apply_vscode_settings
    
    echo ""
    echo "🎉 VSCode font setup completed!"
    echo ""
    echo "📝 Next steps:"
    echo "   1. Restart VSCode to apply font changes"
    echo "   2. If fonts don't appear, check if the fonts are installed in Font Book"
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
    echo "💾 Your existing VSCode settings have been backed up with timestamp"
    echo "🔄 To restore original settings, copy the .backup file back"
else
    echo "This script is for macOS only."
    exit 1
fi
