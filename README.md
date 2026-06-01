# Dotfiles

macOS・Linux・Windows 向け個人用 dotfiles とセットアップスクリプト。  
**XDG Base Directory Specification** に準拠し、`$HOME` 直下を整理した構成です。

## クイックスタート

### ユニバーサルインストーラー（推奨）

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/KenYAMADA/dotfiles/main/install.sh)"
```

OS を自動検出して適切なインストーラーを実行します。

### OS 別インストーラー

#### macOS

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/KenYAMADA/dotfiles/main/install_mac.sh)"
```

- Zsh + Oh My Zsh + Powerlevel10k
- Homebrew パッケージ管理（`Brewfile`）
- Google Cloud SDK（Homebrew 版）
- anyenv / asdf による言語バージョン管理

#### Linux（x86_64 / Raspberry Pi aarch64）

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/KenYAMADA/dotfiles/main/install_linux.sh)"
```

- Zsh + Oh My Zsh + Starship プロンプト
- デフォルトシェルを zsh に自動変更（`chsh`）
- apt / dnf / yum / pacman 対応

#### Windows

```powershell
powershell -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/KenYAMADA/dotfiles/main/install.ps1'))"
```

- PowerShell プロファイル + Starship プロンプト
- winget 統合

## XDG Base Directory Specification

シェル起動時に以下の XDG 変数が `.zshenv` で定義されます：

| 変数 | デフォルト | 用途 |
|---|---|---|
| `XDG_CONFIG_HOME` | `~/.config` | 設定ファイル |
| `XDG_DATA_HOME` | `~/.local/share` | データファイル |
| `XDG_STATE_HOME` | `~/.local/state` | 状態ファイル（履歴等） |
| `XDG_CACHE_HOME` | `~/.cache` | キャッシュ |

主な配置先：

| ツール | パス |
|---|---|
| zsh 設定 (`.zshrc`) | `~/.config/zsh/.zshrc`（`ZDOTDIR` 経由） |
| zsh 履歴 | `~/.local/state/zsh/history` |
| Oh My Zsh | `~/.local/share/oh-my-zsh` |
| anyenv | `~/.local/share/anyenv` |
| Powerlevel10k 設定 | `~/.config/p10k.zsh` |
| Claude Code 設定 | `~/.claude/`（symlink） |

## 構造

### インストールスクリプト
- `install.sh` — OS 検出・ユニバーサルエントリポイント
- `install_mac.sh` / `install_linux.sh` — プラットフォーム別エントリポイント
- `install.ps1` — Windows エントリポイント
- `setup.sh` — メインセットアップ（パッケージ・シンボリックリンク・anyenv）
- `mac_init.sh` / `linux_init.sh` — プラットフォーム別初期化
- `setup.ps1` — Windows セットアップ

### 設定ファイル
- `.zshenv` — 環境変数・XDG 定義・PATH（全 zsh セッション共通）
- `.zshrc` — インタラクティブシェル設定（`~/.config/zsh/.zshrc` に symlink）
- `.zshrc.alias` — エイリアス定義（eza / ls フォールバック付き）
- `p10k.zsh` — Powerlevel10k 設定（`~/.config/p10k.zsh` に symlink、macOS のみ）
- `starship.toml` — Starship プロンプト設定（Gruvbox Dark テーマ、Linux 向け）
- `.vimrc` — Vim 設定
- `.bin/` — カスタムスクリプト（`~/.bin/` に symlink）
- `gh/config.yml` — GitHub CLI 設定（`~/.config/gh/config.yml` に symlink）

### Claude Code 設定
- `claude/settings.json` — Claude Code 設定（autoUpdates・statusLine・hooks）
- `claude/CLAUDE.md` — グローバル指示
- `claude/RTK.md` — RTK ツールドキュメント
- `claude/statusline.sh` — ステータスライン表示スクリプト

### パッケージ管理
- `Brewfile` — macOS 用 Homebrew パッケージ
- `packages/apt.txt` — Debian / Ubuntu
- `packages/dnf.txt` — Fedora / CentOS
- `packages/pacman.txt` — Arch Linux
- `winget_packages.ps1` — Windows

### オプションスクリプト（`scripts/`）
| スクリプト | 用途 |
|---|---|
| `setup_zsh.sh` | Oh My Zsh + プラグイン + Powerlevel10k インストール |
| `setup_colima.sh` | Colima（軽量 Docker デーモン）インストール・自動起動設定 |
| `setup_claude_code.sh` | Claude Code (Anthropic CLI) インストール |
| `setup_antigravity.sh` | Antigravity CLI インストール（macOS） |
| `setup_codex.sh` | OpenAI Codex CLI インストール |
| `setup_cursor.sh` | Cursor (AI コードエディタ) インストール |
| `setup_android.sh` | Android SDK CLI ツール（adb / sdkmanager / platform-tools） |
| `setup_gcloud.sh` | Google Cloud SDK（Homebrew 版） |
| `setup_aws.sh` | AWS CLI |
| `setup_heroku.sh` | Heroku CLI |
| `setup_node.sh` | Node.js（nvm 経由） |
| `setup_vscode_fonts.sh` | VSCode フォント設定 |
| `setup_cursor_fonts.sh` | Cursor フォント設定 |
| `setup_windsurf_fonts.sh` | Windsurf フォント設定 |
| `setup_terminal_fonts.sh` | Terminal.app / iTerm2 フォント設定 |
| `setup_iterm2_profile.sh` | iTerm2 プロファイル作成 |
| `merge_editor_settings.sh` | エディタ設定の安全なマージ |

## OS 別機能

### macOS
- **シェル**: Zsh + Oh My Zsh（plugins: git, zsh-autosuggestions, zsh-completions, zsh-syntax-highlighting）
- **テーマ**: Powerlevel10k（MesloLGS NF フォント推奨）
- **言語管理**: anyenv + asdf
- **クラウド**: AWS CLI・Google Cloud SDK・Heroku CLI（オプション）

### Linux（x86_64 / Raspberry Pi）
- **シェル**: Zsh + Oh My Zsh（テーマなし）
- **プロンプト**: Starship（Gruvbox Dark テーマ）
- **言語管理**: anyenv

### Windows
- **シェル**: PowerShell + Starship プロンプト
- **パッケージ**: winget

## オプションセットアップ

### クラウドツール

```bash
bash ~/dotfiles/scripts/setup_claude_code.sh  # Claude Code
bash ~/dotfiles/scripts/setup_gcloud.sh       # Google Cloud SDK
bash ~/dotfiles/scripts/setup_aws.sh          # AWS CLI
bash ~/dotfiles/scripts/setup_heroku.sh       # Heroku CLI
```

### フォント設定

```bash
bash ~/dotfiles/scripts/setup_vscode_fonts.sh     # VSCode
bash ~/dotfiles/scripts/setup_cursor_fonts.sh     # Cursor
bash ~/dotfiles/scripts/setup_windsurf_fonts.sh   # Windsurf
bash ~/dotfiles/scripts/setup_terminal_fonts.sh   # Terminal.app / iTerm2
```

## 要件

### macOS
- macOS 10.15+（Catalina 以降）
- Xcode Command Line Tools
- インターネット接続

### Linux
- Ubuntu 18.04+ / Fedora 30+ / CentOS 8+ / Arch Linux
- Raspberry Pi OS (aarch64)
- sudo 権限
- インターネット接続

### Windows
- Windows 10/11
- PowerShell 5.1+
- winget
- インターネット接続

## トラブルシューティング

**シェルやプロンプトが反映されない**
```bash
exec zsh   # zsh を再起動
```

**XDG 変数の確認**
```bash
echo $ZDOTDIR          # → ~/.config/zsh
echo $HISTFILE         # → ~/.local/state/zsh/history
echo $ZSH              # → ~/.local/share/oh-my-zsh
```

**p10k テーマを再設定したい**
```bash
p10k configure         # 設定後 ~/.config/p10k.zsh に保存される
```

**anyenv コマンドが見つからない**
```bash
export PATH="$HOME/.local/share/anyenv/bin:$PATH"
eval "$(anyenv init -)"
```

**Permission denied エラー**
```bash
chmod +x ~/dotfiles/*.sh ~/dotfiles/scripts/*.sh
```

## 最新の変更

### v2026.06.01
- **XDG Base Directory Specification 対応**: `.zshenv` で `XDG_*` 変数を定義、`ZDOTDIR` により `.zshrc` を `~/.config/zsh/` へ移動
- **zsh 履歴**: `~/.zsh_history` → `~/.local/state/zsh/history`
- **Oh My Zsh / anyenv**: `~/.local/share/` 以下に配置
- **Linux zsh 化**: デフォルトシェルを bash → zsh に変更（x86_64 / Raspberry Pi）
- **p10k 設定**: `dotfiles/p10k.zsh` として管理、`~/.config/p10k.zsh` に symlink
- **Claude Code 設定**: `dotfiles/claude/` として管理、`~/.claude/` に symlink

### v2026.03.18
- Linux Bash プロンプト表示改善（`TERM=dumb` 環境対応）
- Linux 用 `setup.sh` OS 判定修正
- Windows 用 `install.ps1` / `setup.ps1` 追加

### v2026.03.16
- anyenv 初期化を `.zshenv` → `.zshrc` に移動

### v2026.02.10
- Linux `.bashrc` の色対応判定強化
- `.bashrc.alias` の eza / exa / ls フォールバック整理
