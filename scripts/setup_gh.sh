#!/bin/bash

# This script installs the GitHub CLI (gh).

# Exit the script if an error occurs
set -e

echo "--- Starting GitHub CLI Setup ---"

# Function to install GitHub CLI
install_gh_cli() {
    if command -v gh &> /dev/null; then
        echo "GitHub CLI is already installed."
        gh --version
        return
    fi

    echo "Installing GitHub CLI..."
    case "$(uname -s)" in
        'Darwin')
            # For macOS, use Homebrew
            if ! command -v brew &> /dev/null; then
                echo "Homebrew is not installed. Please install it first." >&2
                exit 1
            fi
            echo "Installing via Homebrew..."
            brew install gh
            ;;
        'Linux')
            echo "Installing via official package repository..."
            if command -v apt-get &> /dev/null; then
                (type -p wget >/dev/null || (sudo apt-get update && sudo apt-get install wget -y)) \
                    && sudo mkdir -p -m 755 /etc/apt/keyrings \
                    && out=$(mktemp) && wget -nv -O"$out" https://cli.github.com/packages/githubcli-archive-keyring.gpg \
                    && cat "$out" | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
                    && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
                    && sudo mkdir -p -m 755 /etc/apt/sources.list.d \
                    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages/stable/deb stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
                    && sudo apt-get update \
                    && sudo apt-get install gh -y
            elif command -v dnf &> /dev/null; then
                sudo dnf install -y 'dnf-command(config-manager)'
                sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
                sudo dnf install -y gh --repo gh-cli
            elif command -v pacman &> /dev/null; then
                sudo pacman -Sy --noconfirm github-cli
            else
                echo "Unsupported package manager. Please install GitHub CLI manually: https://github.com/cli/cli#installation" >&2
                exit 1
            fi
            ;;
        *)
            echo "Unsupported OS: $(uname -s). Please install GitHub CLI manually: https://github.com/cli/cli#installation" >&2
            exit 1
            ;;
    esac

    echo "Verifying installation..."
    gh --version
}

# --- Main Execution ---
install_gh_cli

echo "--- GitHub CLI Setup Finished ---"
echo "You may need to run 'gh auth login' to authenticate."
