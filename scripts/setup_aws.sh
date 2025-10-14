#!/bin/bash

# This script installs and configures the AWS CLI.

# Exit the script if an error occurs
set -e

echo "--- Starting AWS CLI Setup ---"

# Function to install AWS CLI
install_aws_cli() {
    if command -v aws &> /dev/null; then
        echo "AWS CLI is already installed."
        aws --version
        return
    fi

    echo "Installing AWS CLI..."
    case "$(uname -s)" in
        'Darwin')
            # For macOS, use Homebrew
            if ! command -v brew &> /dev/null; then
                echo "Homebrew is not installed. Please install it first." >&2
                exit 1
            fi
            echo "Installing via Homebrew..."
            brew install awscli
            ;;
        'Linux')
            echo "Installing via official AWS CLI v2 installer..."
            ARCH=$(uname -m)
            if [ "$ARCH" = "x86_64" ]; then
                INSTALL_URL="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
            elif [ "$ARCH" = "aarch64" ]; then
                INSTALL_URL="https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip"
            else
                echo "Unsupported Linux architecture: $ARCH. Please install AWS CLI manually." >&2
                exit 1
            fi
            TEMP_DIR=$(mktemp -d)
            curl -sSL "$INSTALL_URL" -o "$TEMP_DIR/awscliv2.zip"
            unzip "$TEMP_DIR/awscliv2.zip" -d "$TEMP_DIR"
            sudo "$TEMP_DIR/aws/install" --update
            rm -rf "$TEMP_DIR"
            ;;
        *)
            echo "Unsupported OS: $(uname -s). Please install AWS CLI manually." >&2
            exit 1
            ;;
    esac

    echo "Verifying installation..."
    aws --version
}

# --- Main Execution ---
install_aws_cli

echo "--- AWS CLI Setup Finished ---"
echo "You may need to run 'aws configure' to set up your credentials."