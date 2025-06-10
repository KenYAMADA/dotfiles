# winget_packages.ps1
#
# WindowsのGUIアプリとVS Code拡張機能をインストールします。

Write-Host "--- Windows アプリケーションのインストールを開始します ---" -ForegroundColor Green
winget source update

# --- wingetでインストールするアプリ ---
$packages = @{
    # 開発ツール
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
    
    # ユーティリティ & コミュニケーション
    "Google Chrome"    = "Google.Chrome";
    "Slack"            = "Slack.Slack";
    "LINE"             = "LINE.LINE";
    "Zoom"             = "Zoom.Zoom";
    "Discord"          = "Discord.Discord";
    "Alfred (PowerToys Run)" = "Microsoft.PowerToys"; # Alfredの代替
    "iTerm2 (Windows Terminal)" = "Microsoft.WindowsTerminal";
}

foreach ($name in $packages.Keys) {
    $id = $packages[$name]
    Write-Host ">>> インストール中: $name ($id)" -ForegroundColor Yellow
    winget install --id $id --source winget --accept-package-agreements --accept-source-agreements
}

# --- VS Code 拡張機能のインストール ---
# Brewfileの'vscode'リストに相当
Write-Host ""
Write-Host "--- VS Code 拡張機能のインストールを開始します ---" -ForegroundColor Green

# VS Codeのコマンドパスが通っているか確認
if ((Get-Command code -ErrorAction SilentlyContinue) -eq $null) {
    Write-Host "VS Codeの'code'コマンドが見つかりません。パスが通っているか確認してください。" -ForegroundColor Red
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
    # Brewfileから必要なものをさらに追加
)

foreach ($ext in $vscode_extensions) {
    Write-Host ">>> VS Code拡張機能のインストール中: $ext" -ForegroundColor Yellow
    code --install-extension $ext --force
}

Write-Host ""
Write-Host "--- 全てのセットアップが完了しました ---" -ForegroundColor Green

