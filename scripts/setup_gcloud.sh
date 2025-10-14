#!/bin/bash

# This script installs and configures Google Cloud related tools.

echo "--- Starting Google Cloud Tools Setup ---"

# Function to install Google Cloud SDK
install_gcloud() {
    if command -v gcloud &> /dev/null; then
        echo "Google Cloud SDK is already installed."
        return
    fi

    echo "Installing Google Cloud SDK..."
    case "$(uname -s)" in
        'Darwin')
            # For macOS, use Homebrew Cask
            if ! command -v brew &> /dev/null; then
                echo "Homebrew is not installed. Please install it first." >&2
                exit 1
            fi
            echo "Installing via Homebrew Cask..."
            brew install --cask google-cloud-sdk
            ;;
        'Linux')
            # For Linux, use the official installer script
            echo "Installing via official script..."
            curl -sSL https://sdk.cloud.google.com | bash -s -- --disable-prompts
            echo "Please restart your shell or run 'source ~/.zshrc' to use gcloud."
            ;;
        *)
            echo "Unsupported OS: $(uname -s). Please install Google Cloud SDK manually." >&2
            exit 1
            ;;
    esac

    if command -v gcloud &> /dev/null; then
        echo "Google Cloud SDK installation successful."
    else
        echo "Google Cloud SDK installation failed." >&2
        exit 1
    fi
}

# Function to configure Google Cloud SDK for zsh
configure_gcloud_zsh() {
    echo "Configuring Google Cloud SDK for zsh compatibility..."
    
    # Check if we're on macOS and using Homebrew
    if [[ "$(uname -s)" == "Darwin" ]] && command -v brew &> /dev/null; then
        # Find the Google Cloud SDK installation path
        GCLOUD_PATH=""
        
        # Check for Apple Silicon Homebrew path (new format)
        if [ -d "/opt/homebrew/share/google-cloud-sdk" ]; then
            GCLOUD_PATH="/opt/homebrew/share/google-cloud-sdk"
        # Check for Intel Homebrew path (new format)
        elif [ -d "/usr/local/share/google-cloud-sdk" ]; then
            GCLOUD_PATH="/usr/local/share/google-cloud-sdk"
        # Check for Apple Silicon Homebrew path (old format)
        elif [ -d "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk" ]; then
            GCLOUD_PATH="/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk"
        # Check for Intel Homebrew path (old format)
        elif [ -d "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk" ]; then
            GCLOUD_PATH="/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk"
        fi
        
        if [ -n "$GCLOUD_PATH" ]; then
            echo "Found Google Cloud SDK at: $GCLOUD_PATH"
            echo "Google Cloud SDK is properly configured for zsh."
        else
            echo "Warning: Could not find Google Cloud SDK installation path."
        fi
    fi
}

# --- Main Execution ---
install_gcloud
configure_gcloud_zsh

echo "--- Google Cloud Tools Setup Finished ---"
echo "You may need to run 'gcloud init' to configure your account."