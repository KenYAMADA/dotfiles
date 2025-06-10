# install.ps1
#
# Windows���̃Z�b�g�A�b�v��1�R�}���h�Ŏ��s���܂��B
# PowerShell�Ŏ��s���Ă��������B

# �G���[�����������ꍇ�̓X�N���v�g���~����
$ErrorActionPreference = "Stop"

# --- �����ݒ� ---
$RepoUrl = "https://github.com/kenyamada/dotfiles.git"
$DotfilesPath = "$HOME\dotfiles"

Write-Host "--- Windows�Z�b�g�A�b�v���J�n���܂� ---" -ForegroundColor Green

# 1. Git�̃C���X�g�[���m�F
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git��������܂���Bwinget���g���ăC���X�g�[�����܂�..."
    winget install --id Git.Git -e --source winget --accept-package-agreements
    
    # Git�̃p�X�����݂̃Z�b�V�����Ɉꎞ�I�ɒǉ�
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    Write-Host "Git���C���X�g�[�����܂����B�����𑱍s���܂��B" -ForegroundColor Green
}

# 2. dotfiles���|�W�g���̃N���[���܂��͍X�V
if (Test-Path -Path $DotfilesPath) {
    Write-Host "$DotfilesPath �͊��ɑ��݂��܂��B�ŐV�̓��e���擾���܂�..."
    try {
        Set-Location -Path $DotfilesPath
        git pull
    } catch {
        Write-Error "���|�W�g���̍X�V�Ɏ��s���܂���: $_"
        exit 1
    }
} else {
    Write-Host "$RepoUrl ����dotfiles���N���[�����܂�..."
    try {
        git clone $RepoUrl $DotfilesPath
    } catch {
        Write-Error "���|�W�g���̃N���[���Ɏ��s���܂���: $_"
        exit 1
    }
}

# 3. Windows�l�C�e�B�u�A�v���̃Z�b�g�A�b�v�X�N���v�g�����s
Set-Location -Path $DotfilesPath
$wingetScriptPath = Join-Path -Path $DotfilesPath -ChildPath "winget_packages.ps1"

if (Test-Path $wingetScriptPath) {
    Write-Host "Windows�l�C�e�B�u�A�v����VS Code�g���@�\�̃C���X�g�[�����J�n���܂�..."
    # ���s�|���V�[�����݂̃v���Z�X�ł̂݃o�C�p�X���ăX�N���v�g�����s
    PowerShell -ExecutionPolicy Bypass -File $wingetScriptPath
} else {
    Write-Warning "$wingetScriptPath ��������܂���ł����B"
}

# 4. WSL (Linux CLI��) �̃Z�b�g�A�b�v�ē�
Write-Host ""
Write-Host "--- WSL (Linux CLI��) �̃Z�b�g�A�b�v�ē� ---" -ForegroundColor Green
Write-Host "���ɁAWSL���C���X�g�[������Linux�R�}���h���C�������\�z���܂��B"

# WSL���C���X�g�[������Ă��邩�m�F
try {
    wsl.exe --status > $null
    $wslInstalled = $true
} catch {
    $wslInstalled = $false
}

if (-not $wslInstalled) {
    Write-Host "WSL���C���X�g�[������Ă��܂���BWSL��Ubuntu���C���X�g�[�����܂�..."
    wsl.exe --install
    Write-Host "WSL�̃C���X�g�[�����������܂����B�R���s���[�^���ċN�����Ă��������B" -ForegroundColor Yellow
    Write-Host "�ċN����A�X�^�[�g���j���[����uUbuntu�v���J���A�����ݒ�i���[�U�[���E�p�X���[�h�j�����������Ă��������B"
    Write-Host "���̌�A�J����Ubuntu�̃^�[�~�i���ňȉ��̃R�}���h�����s����ƁALinux���̃Z�b�g�A�b�v���n�܂�܂��B"
    Write-Host "sh -c `"`$(curl -fsSL https://raw.githubusercontent.com/kenyamada/dotfiles/main/install.sh)`"" -ForegroundColor Cyan
} else {
    Write-Host "WSL�͊��ɃC���X�g�[������Ă��܂��B"
    Write-Host "Linux���̃Z�b�g�A�b�v���s���ɂ́A�X�^�[�g���j���[����uUbuntu�v�Ȃǂ̃f�B�X�g���r���[�V�������J���A"
    Write-Host "�ȉ��̃R�}���h�����s���Ă��������B"
    Write-Host "sh -c `"`$(curl -fsSL https://raw.githubusercontent.com/kenyamada/dotfiles/main/install.sh)`"" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "--- Windows���̃Z�b�g�A�b�v�X�N���v�g���������܂��� ---" -ForegroundColor Green

