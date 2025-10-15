# Dotfiles

このリポジトリには、macOS、Linux、Windows向けの個人用dotfilesとセットアップスクリプトが含まれています。OS固有の最適化が施されています。

## クイックスタート

インストールスクリプトは、このリポジトリを`~/dotfiles`にクローンし、お使いのオペレーティングシステムに適したセットアップスクリプトを実行します。

### ユニバーサルインストーラー（推奨）

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/kenyamada/dotfiles/main/install.sh)"
```

これにより、OSを自動検出して適切なインストーラーを実行します。

### OS別インストーラー

#### macOS（Zsh + Oh My Zsh）

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/kenyamada/dotfiles/main/install_mac.sh)"
```

**機能:**
- Oh My Zshフレームワークを使用したZsh
- Powerlevel10kテーマ
- Homebrewパッケージ管理
- macOS専用アプリケーションとツール
- Google Cloud SDK（Homebrew版）
- Python 3.14対応

#### Linux（Bash中心）

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/kenyamada/dotfiles/main/install_linux.sh)"
```

**機能:**
- 拡張設定付きBashシェル
- システムパッケージマネージャー統合（apt/dnf/yum/pacman）
- 必須開発ツール
- Linux固有の最適化

**⚠️ 注意: Linux版はテスト版です。安定性に問題がある可能性があります。**

#### Windows（PowerShell中心）

```bash
powershell -ExecutionPolicy Bypass -File https://raw.githubusercontent.com/kenyamada/dotfiles/main/install.ps1
```

**機能:**
- PowerShell設定
- Windows Package Manager（winget）統合
- 開発ツールの自動インストール

**⚠️ 注意: Windows版はテスト版です。安定性に問題がある可能性があります。**

## 構造

### コアファイル
- `install.sh`: OSを検出して適切なインストーラーを実行するユニバーサルインストーラー
- `install_mac.sh`: macOS専用インストーラー
- `install_linux.sh`: Linux専用インストーラー
- `install.ps1`: Windows専用インストーラー
- `setup.sh`: OS固有の設定を含むメインセットアップスクリプト

### 設定ファイル
- `.zshrc`, `.zshenv`: Zsh設定（macOS）
- `.bashrc`: Bash設定（Linux）
- `.vimrc`: Vim設定
- `.bin/`: カスタムスクリプトとユーティリティ

### パッケージ管理
- `Brewfile`: macOS用Homebrewパッケージ
- `packages/`: Linuxディストリビューション用システムパッケージ
  - `apt.txt`: Debian/Ubuntuパッケージ
  - `dnf.txt`: Fedora/CentOSパッケージ
  - `pacman.txt`: Arch Linuxパッケージ
- `winget_packages.ps1`: Windows用wingetパッケージ

### セットアップスクリプト
- `mac_init.sh`: macOS固有の初期化
- `linux_init.sh`: Linux固有の初期化
- `scripts/setup_zsh.sh`: Oh My Zshのインストールと設定
- `scripts/setup_aws.sh`: AWS CLIインストール
- `scripts/setup_gcloud.sh`: Google Cloud SDKインストール（Homebrew版）
- `scripts/setup_heroku.sh`: Heroku CLIインストール

## オプションセットアップ

### クラウドツール

これらのツールは、メインセットアップを軽量に保つために個別にインストールされます。メインセットアップ完了後に適切なスクリプトを実行してください：

#### Google Cloud SDK（Homebrew版）
```bash
bash ~/dotfiles/scripts/setup_gcloud.sh
```

#### AWS CLI
```bash
bash ~/dotfiles/scripts/setup_aws.sh
```

#### Heroku CLI
```bash
bash ~/dotfiles/scripts/setup_heroku.sh
```

### フォント設定

エディタとターミナルのフォントを統一するための設定が含まれています。**既存の設定は保持され、フォント設定のみが安全にマージされます。**

#### 個別エディタフォント設定

**VSCode**
```bash
bash ~/dotfiles/scripts/setup_vscode_fonts.sh
```

**Cursor**
```bash
bash ~/dotfiles/scripts/setup_cursor_fonts.sh
```

**Windsurf**
```bash
bash ~/dotfiles/scripts/setup_windsurf_fonts.sh
```

#### ターミナルフォント設定

**macOS Terminal**
```bash
bash ~/dotfiles/scripts/setup_terminal_fonts.sh
```

**iTerm2プロファイル設定**
```bash
bash ~/dotfiles/scripts/setup_iterm2_profile.sh
```

#### 一括設定（上級者向け）

**全エディタ一括設定**
```bash
bash ~/dotfiles/scripts/setup_editor_fonts.sh
```

**安全な設定マージ（手動）**
```bash
bash ~/dotfiles/scripts/merge_editor_settings.sh
```

**対応エディタ:**
- VSCode
- Cursor
- Windsurf

**対応ターミナル:**
- macOS Terminal
- iTerm2

**フォント優先順位:**
1. MesloLGS Nerd Font (Powerlevel10k推奨)
2. HackGenNerd
3. Hack Nerd Font
4. Fira Code
5. Monaco (macOS標準)
6. Menlo (macOS標準)
7. Ubuntu Mono
8. monospace (フォールバック)

**安全な設定マージの特徴:**
- ✅ 既存の設定を保持
- ✅ フォント設定のみを追加/更新
- ✅ 自動バックアップ（タイムスタンプ付き）
- ✅ JSON検証による安全なマージ
- ✅ エラー時の自動復旧
- ✅ 既存設定の復元可能
- ✅ 個別エディタ対応
- ✅ 環境インストール時は実行されない
- ✅ jqなしでも動作（フォールバック機能付き）
- ✅ 自動jqインストール（Homebrew利用時）

## OS固有の機能

### macOS機能
- **シェル**: Oh My Zshフレームワークを使用したZsh
- **テーマ**: MesloLGS NFフォントを使用したPowerlevel10k
- **パッケージマネージャー**: Brewfileを使用したHomebrew
- **アプリケーション**: iTerm2、Alfred、Xcode、開発ツール
- **言語**: anyenv経由のPython、Node.js、Ruby
- **クラウドツール**: AWS CLI、Google Cloud SDK（Homebrew版）、Heroku CLI
- **互換性**: Python 3.14対応、Powerlevel10k instant prompt対応

### Linux機能
- **シェル**: 拡張Bash設定
- **パッケージマネージャー**: apt/dnf/yum/pacmanサポート
- **開発ツール**: Git、Vim、必須CLIツール
- **GUIアプリケーション**: Zoom、Discord（GUI環境が検出された場合）
- **システム統合**: 適切なPATHと環境設定

**⚠️ 注意: Linux版はテスト版です。安定性に問題がある可能性があります。**

## 要件

### macOS
- macOS 10.15+（Catalina以降）
- Xcode Command Line Tools
- パッケージダウンロード用のインターネット接続

### Linux
- Ubuntu 18.04+、Fedora 30+、CentOS 8+、またはArch Linux
- パッケージインストール用のsudo権限
- パッケージダウンロード用のインターネット接続

**⚠️ 注意: Linux版はテスト版です。安定性に問題がある可能性があります。**

### Windows
- Windows 10/11
- PowerShell 5.1以上
- Windows Package Manager（winget）
- パッケージダウンロード用のインターネット接続

**⚠️ 注意: Windows版はテスト版です。安定性に問題がある可能性があります。**

## トラブルシューティング

### よくある問題

1. **Permission denied エラー**: スクリプトに実行権限があることを確認してください
2. **パッケージインストール失敗**: インターネット接続とsudo権限を確認してください
3. **シェルが変更されない**: ターミナルを再起動するか、`source ~/.zshrc`（macOS）または`source ~/.bashrc`（Linux）を実行してください
4. **Google Cloud SDKエラー**: Homebrew版を使用していることを確認し、Python 3.14との互換性を確認してください

### 手動インストール

自動インストーラーが失敗した場合、手動でクローンしてセットアップを実行できます：

```bash
git clone https://github.com/kenyamada/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x *.sh scripts/*.sh
./setup.sh
```

## 最新の変更

### v2025.10.14
- Google Cloud SDKをHomebrew版に移行
- Python 3.14との互換性問題を解決
- Powerlevel10k instant promptとの互換性を改善
- パッケージ管理の統一化
- 既存環境との後方互換性を保持
