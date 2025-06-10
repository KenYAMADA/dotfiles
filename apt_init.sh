#!/bin/bash

if [ "$(uname)" != "Linux" ] ; then
	echo "Not Linux!"
	exit 1
fi

# --- CPUアーキテクチャの判別 ---
ARCH_TYPE=""
case $(uname -m) in
  x86_64)
    ARCH_TYPE="amd64"
    ;;
  aarch64)
    ARCH_TYPE="arm64"
    ;;
  *)
    echo "サポートされていないCPUアーキテクチャです: $(uname -m)"
    # 互換性のあるものを設定するか、ここで終了させる
    ARCH_TYPE="amd64" 
    ;;
esac
echo "CPUアーキテクチャを ${ARCH_TYPE} として認識しました。"


## Google SQL Auth Proxy (Linux版)
curl -o ~/.bin/cloud_sql_proxy "https://dl.google.com/cloudsql/cloud_sql_proxy.linux.${ARCH_TYPE}"
chmod +x ~/.bin/cloud_sql_proxy

## vim plugin
if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

## anyenv setup: install plugins
anyenv install rbenv
anyenv install pyenv
anyenv install nodenv
anyenv install goenv
anyenv install jenv

# GitHub CLI config
mkdir -p $HOME/.config/gh && ln -snf $HOME/dotfiles/gh/config.yml $HOME/.config/gh/config.yml

## Install packages via other methods
# ------------------------------------
# Install Heroku CLI
curl https://cli-assets.heroku.com/install.sh | sh
# Install Mackup
pip3 install mackup


# --- GUIアプリケーションのインストール ---
# $DISPLAY変数が存在する場合のみGUIアプリをインストールする
if [ -n "$DISPLAY" ]; then
    echo "GUI環境を検出しました。GUIアプリケーションをインストールします..."

    # Install Zoom
    if ! command -v zoom &> /dev/null; then
        echo "Zoomをインストール中..."
        wget "https://zoom.us/client/latest/zoom_${ARCH_TYPE}.deb" -O /tmp/zoom.deb
        sudo apt install -y /tmp/zoom.deb
        rm /tmp/zoom.deb
    fi

    # Install Discord (注意: DiscordはARM64に公式対応していない可能性が高い)
    if [ "$ARCH_TYPE" = "amd64" ]; then
        if ! command -v discord &> /dev/null; then
            echo "Discordをインストール中..."
            wget "https://discord.com/api/download?platform=linux&format=deb" -O /tmp/discord.deb
            sudo apt install -y /tmp/discord.deb
            rm /tmp/discord.deb
        fi
    else
        echo "Discordはamd64以外のアーキテクチャをサポートしていないため、インストールをスキップします。"
    fi
else
    echo "GUI環境が検出されませんでした。GUIアプリケーションのインストールはスキップします。"
fi


echo "Linux init script finished."

