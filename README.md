# My Dotfiles

This repository contains my personal dotfiles and setup scripts for macOS and Linux with OS-specific optimizations.

## Quick Start

The installation scripts will clone this repository to `~/dotfiles` and run the appropriate setup script for your operating system.

### Universal Installer (Recommended)

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/kenyamada/dotfiles/main/install.sh)"
```

This will automatically detect your OS and run the appropriate installer.

### OS-Specific Installers

#### macOS (Zsh + Oh My Zsh)

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/kenyamada/dotfiles/main/install_mac.sh)"
```

**Features:**
- Zsh with Oh My Zsh framework
- Powerlevel10k theme
- Homebrew package management
- macOS-specific applications and tools

#### Linux (Bash-focused)

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/kenyamada/dotfiles/main/install_linux.sh)"
```

**Features:**
- Bash shell with enhanced configuration
- System package manager integration (apt/dnf/yum/pacman)
- Essential development tools
- Linux-specific optimizations

## Structure

### Core Files
- `install.sh`: Universal installer that detects OS and runs appropriate installer
- `install_mac.sh`: macOS-specific installer
- `install_linux.sh`: Linux-specific installer
- `setup.sh`: Main setup script with OS-specific configurations

### Configuration Files
- `.zshrc`, `.zshenv`: Zsh configuration (macOS)
- `.bashrc`: Bash configuration (Linux)
- `.vimrc`: Vim configuration
- `.bin/`: Custom scripts and utilities

### Package Management
- `Brewfile`: Homebrew packages for macOS
- `packages/`: System packages for Linux distributions
  - `apt.txt`: Debian/Ubuntu packages
  - `dnf.txt`: Fedora/CentOS packages
  - `pacman.txt`: Arch Linux packages

### Setup Scripts
- `mac_init.sh`: macOS-specific initializations
- `linux_init.sh`: Linux-specific initializations
- `scripts/setup_zsh.sh`: Oh My Zsh installation and configuration
- `scripts/setup_aws.sh`: AWS CLI installation
- `scripts/setup_gcloud.sh`: Google Cloud SDK installation
- `scripts/setup_heroku.sh`: Heroku CLI installation

## Optional Setups

### Cloud Tools

These tools are installed separately to keep the main setup lean. Run the appropriate script after the main setup is complete:

#### Google Cloud SDK
```bash
bash ~/dotfiles/scripts/setup_gcloud.sh
```

#### AWS CLI
```bash
bash ~/dotfiles/scripts/setup_aws.sh
```

#### Heroku CLI
```bash
bash ~/dotfiles/scripts/setup_heroku.sh
```

## OS-Specific Features

### macOS Features
- **Shell**: Zsh with Oh My Zsh framework
- **Theme**: Powerlevel10k with MesloLGS NF font
- **Package Manager**: Homebrew with Brewfile
- **Applications**: iTerm2, Alfred, Xcode, development tools
- **Languages**: Python, Node.js, Ruby via anyenv
- **Cloud Tools**: AWS CLI, Google Cloud SDK, Heroku CLI

### Linux Features
- **Shell**: Enhanced Bash configuration
- **Package Managers**: apt/dnf/yum/pacman support
- **Development Tools**: Git, Vim, essential CLI tools
- **GUI Applications**: Zoom, Discord (when GUI environment detected)
- **System Integration**: Proper PATH and environment setup

## Requirements

### macOS
- macOS 10.15+ (Catalina or later)
- Xcode Command Line Tools
- Internet connection for package downloads

### Linux
- Ubuntu 18.04+, Fedora 30+, CentOS 8+, or Arch Linux
- sudo privileges for package installation
- Internet connection for package downloads

## Troubleshooting

### Common Issues

1. **Permission denied errors**: Ensure scripts have execute permissions
2. **Package installation failures**: Check internet connection and sudo privileges
3. **Shell not changing**: Restart terminal or run `source ~/.zshrc` (macOS) or `source ~/.bashrc` (Linux)

### Manual Installation

If the automated installer fails, you can manually clone and run the setup:

```bash
git clone https://github.com/kenyamada/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x *.sh scripts/*.sh
./setup.sh
```