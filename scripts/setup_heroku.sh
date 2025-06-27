#!/bin/bash

# This script installs and configures the Heroku CLI.

# Exit the script if an error occurs
set -e

echo "--- Starting Heroku CLI Setup ---"

# Function to install Heroku CLI
install_heroku_cli() {
    if command -v heroku &> /dev/null; then
        echo "Heroku CLI is already installed."
        heroku --version
        return
    fi

    echo "Installing Heroku CLI..."
    case "$(uname -s)" in
        'Darwin')
            # For macOS, use Homebrew
            if ! command -v brew &> /dev/null; then
                echo "Homebrew is not installed. Please install it first." >&2
                exit 1
            fi
            echo "Installing via Homebrew..."
            # The official recommendation is to use their tap
            brew tap heroku/brew && brew install heroku
            ;;
        'Linux')
            # For Linux, use the official installer script
            echo "Installing via official script..."
            curl https://cli-assets.heroku.com/install.sh | sh
            ;;
        *)
            echo "Unsupported OS: $(uname -s). Please install Heroku CLI manually." >&2
            exit 1
            ;;
    esac

    echo "Verifying installation..."
    heroku --version
}

# --- Main Execution ---
install_heroku_cli

echo "--- Heroku CLI Setup Finished ---"
echo "You may need to run 'heroku login' to authenticate."