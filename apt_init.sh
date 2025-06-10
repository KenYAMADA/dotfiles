#!/bin/bash

if [ "$(uname)" != "Linux" ] ; then
	echo "Not Linux!"
	exit 1
fi

## Google SQL Auth Proxy (Linux版)
curl -o ~/.bin/cloud_sql_proxy https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64
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

echo "Linux init script finished."
