$ErrorActionPreference = "Stop"

$Dotpath = Split-Path -Parent $MyInvocation.MyCommand.Path
$StarshipConfigSource = Join-Path $Dotpath "starship.toml"
$StarshipConfigDir = Join-Path $HOME ".config"
$StarshipConfigTarget = Join-Path $StarshipConfigDir "starship.toml"
$ProfileSource = Join-Path $Dotpath "windows\Microsoft.PowerShell_profile.ps1"
$ProfileTarget = $PROFILE.CurrentUserCurrentHost

function Backup-FileIfExists {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if (Test-Path $Path) {
        Copy-Item $Path "$Path.bak" -Force
    }
}

Write-Host "Starting Windows setup..." -ForegroundColor Green

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "winget is not available. Skipping Starship installation." -ForegroundColor Yellow
} elseif (-not (Get-Command starship -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Starship prompt..." -ForegroundColor Yellow
    winget install --id Starship.Starship --source winget --accept-package-agreements --accept-source-agreements
} else {
    Write-Host "Starship is already installed." -ForegroundColor Cyan
}

if (Test-Path $StarshipConfigSource) {
    New-Item -ItemType Directory -Path $StarshipConfigDir -Force | Out-Null
    Copy-Item $StarshipConfigSource $StarshipConfigTarget -Force
    Write-Host "Starship configuration copied to $StarshipConfigTarget" -ForegroundColor Cyan
}

if (Test-Path $ProfileSource) {
    $ProfileDir = Split-Path -Parent $ProfileTarget
    New-Item -ItemType Directory -Path $ProfileDir -Force | Out-Null
    Backup-FileIfExists -Path $ProfileTarget
    Copy-Item $ProfileSource $ProfileTarget -Force
    Write-Host "PowerShell profile installed to $ProfileTarget" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "Windows setup complete." -ForegroundColor Green
Write-Host "Open a new PowerShell window to load the updated profile." -ForegroundColor Green
