#!/bin/bash

# This script installs and configures AWS related tools.

echo "--- Starting AWS Tools Setup ---"

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
            # For Linux, use the official bundled installer
            echo "Installing via official script..."
            ARCH=$(uname -m)
            if [ "$ARCH" = "x86_64" ]; then
                curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
            elif [ "$ARCH" = "aarch64" ]; then
                curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
            else
                echo "Unsupported Linux architecture for AWS CLI: $ARCH" >&2
                exit 1
            fi
            
            unzip awscliv2.zip
            sudo ./aws/install
            rm -rf aws awscliv2.zip
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

echo "--- AWS Tools Setup Finished ---"
echo "You may need to run 'aws configure' to set up your credentials."