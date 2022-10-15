#!/bin/bash

if [ "$(uname)" != "Darwin" ] ; then
	echo "Not macOS!"
	exit 1
fi

## iTerm shell integration
## https://iterm2.com/documentation-shell-integration.html
## https://www.rasukarusan.com/entry/2019/04/13/180443
curl -L https://iterm2.com/misc/install_shell_integration.sh | bash

## Google SQL Auth Proxy
## https://cloud.google.com/sql/docs/mysql/sql-proxy?hl=ja#install
curl -o ~/.bin/cloud_sql_proxy https://dl.google.com/cloudsql/cloud_sql_proxy.darwin.amd64
chmod +x ~/.bin/cloud_sql_proxy

## vim plugin
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

## anyenv setup
# install rbenv pyenv nodenv
anyenv install --init
anyenv install rbenv
anyenv install pyenv
anyenv install nodenv
anyenv install go

# config
mkdir -p $HOME/.config/gh & ln -s $HOME/dotfiles/gh/config.yml $HOME/.config/gh/config.yml

