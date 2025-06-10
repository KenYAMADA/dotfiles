# winget_packages.ps1
#
# Windows��GUI�A�v����VS Code�g���@�\���C���X�g�[�����܂��B

Write-Host "--- Windows �A�v���P�[�V�����̃C���X�g�[�����J�n���܂� ---" -ForegroundColor Green
winget source update

# --- winget�ŃC���X�g�[������A�v�� ---
$packages = @{
    # �J���c�[��
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
    
    # ���[�e�B���e�B & �R�~���j�P�[�V����
    "Google Chrome"    = "Google.Chrome";
    "Slack"            = "Slack.Slack";
    "LINE"             = "LINE.LINE";
    "Zoom"             = "Zoom.Zoom";
    "Discord"          = "Discord.Discord";
    "Alfred (PowerToys Run)" = "Microsoft.PowerToys"; # Alfred�̑��
    "iTerm2 (Windows Terminal)" = "Microsoft.WindowsTerminal";
}

foreach ($name in $packages.Keys) {
    $id = $packages[$name]
    Write-Host ">>> �C���X�g�[����: $name ($id)" -ForegroundColor Yellow
    winget install --id $id --source winget --accept-package-agreements --accept-source-agreements
}

# --- VS Code �g���@�\�̃C���X�g�[�� ---
# Brewfile��'vscode'���X�g�ɑ���
Write-Host ""
Write-Host "--- VS Code �g���@�\�̃C���X�g�[�����J�n���܂� ---" -ForegroundColor Green

# VS Code�̃R�}���h�p�X���ʂ��Ă��邩�m�F
if ((Get-Command code -ErrorAction SilentlyContinue) -eq $null) {
    Write-Host "VS Code��'code'�R�}���h��������܂���B�p�X���ʂ��Ă��邩�m�F���Ă��������B" -ForegroundColor Red
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
    # Brewfile����K�v�Ȃ��̂�����ɒǉ�
)

foreach ($ext in $vscode_extensions) {
    Write-Host ">>> VS Code�g���@�\�̃C���X�g�[����: $ext" -ForegroundColor Yellow
    code --install-extension $ext --force
}

Write-Host ""
Write-Host "--- �S�ẴZ�b�g�A�b�v���������܂��� ---" -ForegroundColor Green

