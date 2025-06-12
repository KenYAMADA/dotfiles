# install.ps1
#
# Execute Windows environment setup with a single command.
# Run this script with PowerShell.

# Stop the script if an error occurs
$ErrorActionPreference = "Stop"

# --- Initial Settings ---
$RepoUrl = "https://github.com/kenyamada/dotfiles.git"
$DotfilesPath = "$HOME\dotfiles"

Write-Host "--- Starting Windows Setup ---" -ForegroundColor Green

# 1. Check Git installation
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git not found. Installing via winget..."
    winget install --id Git.Git -e --source winget --accept-package-agreements
    
    # Temporarily add Git path to current session
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    Write-Host "Git installed successfully. Continuing process." -ForegroundColor Green
}

# 2. Clone or update dotfiles repository
if (Test-Path -Path $DotfilesPath) {
    Write-Host "$DotfilesPath already exists. Fetching latest content..."
    try {
        Set-Location -Path $DotfilesPath
        git pull
    } catch {
        Write-Error "Failed to update repository: $_"
        exit 1
    }
} else {
    Write-Host "Cloning dotfiles from $RepoUrl..."
    try {
        git clone $RepoUrl $DotfilesPath
    } catch {
        Write-Error "Failed to clone repository: $_"
        exit 1
    }
}

# 3. Execute Windows native app setup script
Set-Location -Path $DotfilesPath
$wingetScriptPath = Join-Path -Path $DotfilesPath -ChildPath "winget_packages.ps1"

if (Test-Path $wingetScriptPath) {
    Write-Host "Starting installation of Windows native apps and VS Code extensions..."
    # Execute script by bypassing execution policy for current process only
    PowerShell -ExecutionPolicy Bypass -File $wingetScriptPath
} else {
    Write-Warning "$wingetScriptPath not found."
}

# 4. WSL (Linux CLI environment) setup guide
Write-Host ""
Write-Host "--- WSL (Linux CLI Environment) Setup Guide ---" -ForegroundColor Green
Write-Host "Next, install WSL to build a Linux command line environment."

# Check if WSL is installed
try {
    wsl.exe --status > $null
    $wslInstalled = $true
} catch {
    $wslInstalled = $false
}

if (-not $wslInstalled) {
    Write-Host "WSL is not installed. Installing WSL and Ubuntu..."
    wsl.exe --install
    Write-Host "WSL installation completed. Please restart your computer." -ForegroundColor Yellow
    Write-Host "After restart, open 'Ubuntu' from the Start menu and complete the initial setup (username and password)."
    Write-Host "Then, run the following command in the opened Ubuntu terminal to start Linux environment setup:"
    Write-Host "sh -c `"`$(curl -fsSL https://raw.githubusercontent.com/kenyamada/dotfiles/main/install.sh)`"" -ForegroundColor Cyan
} else {
    Write-Host "WSL is already installed."
    Write-Host "To set up the Linux environment, open a distribution like 'Ubuntu' from the Start menu and"
    Write-Host "run the following command:"
    Write-Host "sh -c `"`$(curl -fsSL https://raw.githubusercontent.com/kenyamada/dotfiles/main/install.sh)`"" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "--- Windows Setup Script Completed ---" -ForegroundColor Green