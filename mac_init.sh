#!/bin/bash

if [ "$(uname)" != "Darwin" ] ; then
	echo "Not macOS!"
	exit 1
fi

# Mac用の設定
## .DS_Storeを作成しない。
defaults write com.apple.desktopservices DSDontWriteNetworkStores True
## screenshot
defaults write com.apple.screencapture name "ss"
mkdir -p $HOME/Pictures/ScreenShots/
defaults write com.apple.screencapture location $HOME/Pictures/ScreenShots/
defaults write com.apple.dock springboard-columns -int 10
defaults write com.apple.dock springboard-rows -int 6
defaults write com.apple.dock ResetLaunchPad -bool TRUE
killall Dock

## iTerm shell integration
## https://iterm2.com/documentation-shell-integration.html
curl -L https://iterm2.com/misc/install_shell_integration.sh | bash

## Google SQL Auth Proxy
## https://cloud.google.com/sql/docs/mysql/sql-proxy?hl=ja#install
curl -o ~/.bin/cloud_sql_proxy https://dl.google.com/cloudsql/cloud_sql_proxy.darwin.amd64
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

# config
mkdir -p $HOME/.config/gh && ln -snf $HOME/dotfiles/gh/config.yml $HOME/.config/gh/config.yml

