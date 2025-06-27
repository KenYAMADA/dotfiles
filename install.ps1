<#
.SYNOPSIS
    This script clones the dotfiles repository and prepares the setup for Windows.
.DESCRIPTION
    It checks for Git, clones the repository, and then executes the main setup.ps1 script.
.EXAMPLE
    Set-ExecutionPolicy RemoteSigned -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/kenyamada/dotfiles/main/install.ps1'))
#>

# Exit on error
$ErrorActionPreference = "Stop"

# --- Configuration ---
$RepoUrl = "https://github.com/kenyamada/dotfiles.git"
$Dotpath = "$HOME\dotfiles"

# --- Execution ---

# 1. Check for Git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git is not installed or not in your PATH."
    Write-Host "Please install Git and try again. You can get it from https://git-scm.com/"
    exit 1
}

# 2. Clone or update the dotfiles repository
if (Test-Path $Dotpath) {
    Write-Host "$Dotpath already exists. Fetching the latest content..."
    Set-Location $Dotpath
    git pull
    Set-Location $HOME
} else {
    Write-Host "Cloning dotfiles from $RepoUrl..."
    git clone $RepoUrl $Dotpath
}

# 3. Execute the main setup script
Write-Host "Moving to $Dotpath to start the main setup..."
Set-Location $Dotpath
./setup.ps1

Write-Host ""
Write-Host "Windows setup preparation complete! Please check for further instructions."