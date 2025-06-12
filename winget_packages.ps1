# winget_packages.ps1
#
# Install Windows GUI applications and VS Code extensions.

Write-Host "--- Starting Windows Application Installation ---" -ForegroundColor Green
winget source update

# --- Applications to install via winget ---
$packages = @{
    # Development Tools
    "Visual Studio Code" = "Microsoft.VisualStudioCode";
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
    "Alfred (PowerToys Run)" = "Microsoft.PowerToys"; # Alternative to Alfred
    "iTerm2 (Windows Terminal)" = "Microsoft.WindowsTerminal";
}

foreach ($name in $packages.Keys) {
    $id = $packages[$name]
    Write-Host ">>> Installing: $name ($id)" -ForegroundColor Yellow
    winget install --id $id --source winget --accept-package-agreements --accept-source-agreements
}

# --- VS Code Extensions Installation ---
# Equivalent to 'vscode' list in Brewfile
Write-Host ""
Write-Host "--- Starting VS Code Extensions Installation ---" -ForegroundColor Green

# Check if VS Code command path is available
if ((Get-Command code -ErrorAction SilentlyContinue) -eq $null) {
    Write-Host "VS Code 'code' command not found. Please verify the path is configured correctly." -ForegroundColor Red
    exit
}

$vscode_extensions = @(
    "github.vscode-pull-request-github",
    "eamodio.gitlens",
    "ms-python.python",
    "ms-python.vscode-pylance",
    "ms-azuretools.vscode-docker",
    "redhat.java",
    "vscjava.vscode-java-pack",
    "ms-dotnettools.csdevkit",
    "golang.go",
    "rust-lang.rust-analyzer",
    "hashicorp.terraform",
    "googlecloudtools.cloudcode",
    "amazonwebservices.aws-toolkit-vscode",
    "yzhang.markdown-all-in-one",
    "ms-ceintl.vscode-language-pack-ja"
    # Add more extensions from Brewfile as needed
)

foreach ($ext in $vscode_extensions) {
    Write-Host ">>> Installing VS Code extension: $ext" -ForegroundColor Yellow
    code --install-extension $ext --force
}

Write-Host ""
Write-Host "--- All Setup Completed ---" -ForegroundColor Green