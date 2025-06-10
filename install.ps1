# install.ps1
#
# Windows環境のセットアップを1コマンドで実行します。
# PowerShellで実行してください。

# エラーが発生した場合はスクリプトを停止する
$ErrorActionPreference = "Stop"

# --- 初期設定 ---
$RepoUrl = "https://github.com/kenyamada/dotfiles.git"
$DotfilesPath = "$HOME\dotfiles"

Write-Host "--- Windowsセットアップを開始します ---" -ForegroundColor Green

# 1. Gitのインストール確認
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Gitが見つかりません。wingetを使ってインストールします..."
    winget install --id Git.Git -e --source winget --accept-package-agreements
    
    # Gitのパスを現在のセッションに一時的に追加
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    Write-Host "Gitをインストールしました。処理を続行します。" -ForegroundColor Green
}

# 2. dotfilesリポジトリのクローンまたは更新
if (Test-Path -Path $DotfilesPath) {
    Write-Host "$DotfilesPath は既に存在します。最新の内容を取得します..."
    try {
        Set-Location -Path $DotfilesPath
        git pull
    } catch {
        Write-Error "リポジトリの更新に失敗しました: $_"
        exit 1
    }
} else {
    Write-Host "$RepoUrl からdotfilesをクローンします..."
    try {
        git clone $RepoUrl $DotfilesPath
    } catch {
        Write-Error "リポジトリのクローンに失敗しました: $_"
        exit 1
    }
}

# 3. Windowsネイティブアプリのセットアップスクリプトを実行
Set-Location -Path $DotfilesPath
$wingetScriptPath = Join-Path -Path $DotfilesPath -ChildPath "winget_packages.ps1"

if (Test-Path $wingetScriptPath) {
    Write-Host "WindowsネイティブアプリとVS Code拡張機能のインストールを開始します..."
    # 実行ポリシーを現在のプロセスでのみバイパスしてスクリプトを実行
    PowerShell -ExecutionPolicy Bypass -File $wingetScriptPath
} else {
    Write-Warning "$wingetScriptPath が見つかりませんでした。"
}

# 4. WSL (Linux CLI環境) のセットアップ案内
Write-Host ""
Write-Host "--- WSL (Linux CLI環境) のセットアップ案内 ---" -ForegroundColor Green
Write-Host "次に、WSLをインストールしてLinuxコマンドライン環境を構築します。"

# WSLがインストールされているか確認
try {
    wsl.exe --status > $null
    $wslInstalled = $true
} catch {
    $wslInstalled = $false
}

if (-not $wslInstalled) {
    Write-Host "WSLがインストールされていません。WSLとUbuntuをインストールします..."
    wsl.exe --install
    Write-Host "WSLのインストールが完了しました。コンピュータを再起動してください。" -ForegroundColor Yellow
    Write-Host "再起動後、スタートメニューから「Ubuntu」を開き、初期設定（ユーザー名・パスワード）を完了させてください。"
    Write-Host "その後、開いたUbuntuのターミナルで以下のコマンドを実行すると、Linux環境のセットアップが始まります。"
    Write-Host "sh -c `"`$(curl -fsSL https://raw.githubusercontent.com/kenyamada/dotfiles/main/install.sh)`"" -ForegroundColor Cyan
} else {
    Write-Host "WSLは既にインストールされています。"
    Write-Host "Linux環境のセットアップを行うには、スタートメニューから「Ubuntu」などのディストリビューションを開き、"
    Write-Host "以下のコマンドを実行してください。"
    Write-Host "sh -c `"`$(curl -fsSL https://raw.githubusercontent.com/kenyamada/dotfiles/main/install.sh)`"" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "--- Windows側のセットアップスクリプトが完了しました ---" -ForegroundColor Green

