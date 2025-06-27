# My Dotfiles

This repository contains my personal dotfiles and setup scripts for macOS, Linux, and Windows.

## Quick Start

The installation scripts will clone this repository to `~/dotfiles` (or `$HOME\dotfiles` on Windows) and then run the main setup script for the detected operating system.

### macOS & Linux

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/kenyamada/dotfiles/main/install.sh)"
```

This will clone the repository to `~/dotfiles` and execute the main `setup.sh` script.

## Structure

- `setup.sh`: The main setup script that detects the OS and orchestrates the installation.
- `mac_init.sh`: macOS-specific initializations.
- `linux_init.sh`: Linux-specific initializations.
- `Brewfile`: A list of packages to be installed via Homebrew on macOS.
- `packages/`: Contains package lists for various Linux distributions.

## Optional Setups

### Google Cloud Tools

Installation for Google Cloud SDK (`gcloud`, `gsutil`, `cloud_sql_proxy`, etc.) has been separated to keep the main setup lean. If you need Google Cloud tools, run the following script after the main setup is complete:

```bash
bash ~/dotfiles/scripts/setup_gcloud.sh
```