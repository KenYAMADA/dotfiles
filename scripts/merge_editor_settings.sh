#!/bin/bash

# Safe Editor Settings Merger
# This script safely merges font settings with existing editor configurations

set -e

echo "🔧 Safely merging editor font settings..."

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
        echo "⚠️  jq not found. Installing jq for safe JSON merging..."
        if command -v brew &> /dev/null; then
            brew install jq
        else
            echo "❌ Cannot install jq automatically. Please install jq manually or the settings will be overwritten."
            read -p "Continue with overwrite? (y/N): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                echo "Skipping $editor_name settings merge."
                return 1
            fi
            cp "$source_file" "$target_file"
            return 0
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
    fi
}

# Function to apply Cursor settings
apply_cursor_settings() {
    local cursor_dir="$HOME/Library/Application Support/Cursor/User"
    local settings_file="$cursor_dir/settings.json"
    local source_file="$HOME/dotfiles/scripts/cursor_settings.json"
    
    if [ -d "$cursor_dir" ]; then
        merge_json_settings "$settings_file" "$source_file" "Cursor"
    else
        echo "⚠️  Cursor not found, skipping configuration"
    fi
}

# Function to apply Windsurf settings
apply_windsurf_settings() {
    local windsurf_dir="$HOME/Library/Application Support/Windsurf/User"
    local settings_file="$windsurf_dir/settings.json"
    local source_file="$HOME/dotfiles/scripts/windsurf_settings.json"
    
    if [ -d "$windsurf_dir" ]; then
        merge_json_settings "$settings_file" "$source_file" "Windsurf"
    else
        echo "⚠️  Windsurf not found, skipping configuration"
    fi
}

# Function to show merge summary
show_merge_summary() {
    echo ""
    echo "📋 Merge Summary:"
    echo "=================="
    
    # Check VSCode
    if [ -f "$HOME/Library/Application Support/Code/User/settings.json" ]; then
        echo "✅ VSCode: Settings merged"
    else
        echo "⚠️  VSCode: No settings found"
    fi
    
    # Check Cursor
    if [ -f "$HOME/Library/Application Support/Cursor/User/settings.json" ]; then
        echo "✅ Cursor: Settings merged"
    else
        echo "⚠️  Cursor: No settings found"
    fi
    
    # Check Windsurf
    if [ -f "$HOME/Library/Application Support/Windsurf/User/settings.json" ]; then
        echo "✅ Windsurf: Settings merged"
    else
        echo "⚠️  Windsurf: No settings found"
    fi
    
    echo ""
    echo "💾 Backups created with timestamp in the same directories"
    echo "🔄 To restore original settings, copy the .backup files back"
}

# Main execution
if [[ "$(uname)" == "Darwin" ]]; then
    apply_vscode_settings
    apply_cursor_settings
    apply_windsurf_settings
    show_merge_summary
    
    echo ""
    echo "🎉 Safe editor settings merge completed!"
    echo "📝 Please restart your editors to apply the font changes."
else
    echo "This script is for macOS only."
    exit 1
fi

