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
            # For macOS, use Homebrew
            if ! command -v brew &> /dev/null; then
                echo "Homebrew is not installed. Please install it first." >&2
                exit 1
            fi
            echo "Installing via Homebrew..."
            brew install google-cloud-sdk
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

# --- Main Execution ---
install_gcloud

echo "--- Google Cloud Tools Setup Finished ---"
echo "You may need to run 'gcloud init' to configure your account."