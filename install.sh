#!/bin/bash
#
# このスクリプトはdotfilesをクローンし、セットアップを開始します。
# 実行コマンド:
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/kenyamada/dotfiles/main/install.sh)"
#

# エラーが発生したらスクリプトを終了する
set -e

# --- 設定 (環境に合わせて変更してください) ---
# GitHubのユーザー名とリポジトリ名
REPO_URL="https://github.com/kenyamada/dotfiles.git"
# dotfilesをクローンする場所
DOTPATH="$HOME/dotfiles"

# --- 実行部分 ---

# 1. 前提となるgitコマンドの存在を確認・インストール
if ! command -v git &> /dev/null; then
  echo "Gitがインストールされていません。インストールを試みます..."
  # OSの種類を判定
  case "$(uname -s)" in
    'Darwin')
      # macOSの場合、Xcode Command Line Toolsのインストールを促す
      # これによりgitがインストールされる (ユーザーの操作が必要)
      echo "Xcode Command Line Toolsのインストールを開始します..."
      xcode-select --install
      ;;
    'Linux')
      # Debian/Ubuntu系Linuxの場合
      if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y git
      # RedHat/CentOS系Linuxの場合
      elif command -v yum &> /dev/null; then
        sudo yum install -y git
      else
        echo "'apt-get'または'yum'が見つかりませんでした。手動でGitをインストールしてください。"
        exit 1
      fi
      ;;
    *)
      echo "サポートされていないOSです: $(uname -s)。手動でGitをインストールしてください。"
      exit 1
      ;;
  esac
fi

# 2. dotfilesリポジトリをクローン
if [ -d "$DOTPATH" ]; then
  echo "$DOTPATH は既に存在します。最新の内容を取得します..."
  cd "$DOTPATH"
  git pull
  cd "$HOME"
else
  echo "$REPO_URL からdotfilesをクローンします..."
  git clone "$REPO_URL" "$DOTPATH"
fi

# 3. メインのセットアップスクリプトを実行
echo "$DOTPATH に移動してメインのセットアップを開始します..."
cd "$DOTPATH"
# setup.shに実行権限を付与
chmod +x setup.sh
./setup.sh

echo ""
echo "セットアップが完了しました！シェルを再起動して変更を反映させてください。"

