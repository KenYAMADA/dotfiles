# winget_packages.ps1
#
# Install Windows GUI applications.

Write-Host "--- Starting Windows Application Installation ---" -ForegroundColor Green
winget source update

# --- Applications to install via winget ---
$packages = @{
    # Development Tools
    "Git"                = "Git.Git";
    "Docker Desktop"     = "Docker.DockerDesktop";
    "PowerToys"          = "Microsoft.PowerToys";
    "AWS CLI"            = "Amazon.AWSCLI";
    "MySQL"              = "Oracle.MySQL";
    "PostgreSQL"         = "PostgreSQL.PostgreSQL";
    "CMake"              = "Kitware.CMake";
    "Yarn"               = "Yarn.Yarn";
    "Python 3.12"        = "Python.Python.3.12";
    
    # Utilities & Communication
    "Google Chrome"    = "Google.Chrome";
    "Slack"            = "Slack.Slack";
    "LINE"             = "LINE.LINE";
    "Zoom"             = "Zoom.Zoom";
    "Discord"          = "Discord.Discord";
}

foreach ($name in $packages.Keys) {
    $id = $packages[$name]
    Write-Host ">>> Installing: $name ($id)" -ForegroundColor Yellow
    winget install --id $id --source winget --accept-package-agreements --accept-source-agreements
}

Write-Host ""
Write-Host "--- All Setup Completed ---" -ForegroundColor Green
