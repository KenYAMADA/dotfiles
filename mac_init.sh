#!/bin/bash

if [ "$(uname)" != "Darwin" ] ; then
	echo "Not macOS!"
	exit 1
fi

echo "Set zsh"
chsh -s /bin/zsh

echo "Install xcode"
xcode-select --install > /dev/null

echo "installing Homebrew ..."
which brew >/dev/null 2>&1 || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

echo "run brew doctor ..."
which brew >/dev/null 2>&1 && brew doctor

echo "run brew update ..."
which brew >/dev/null 2>&1 && brew update

echo "ok. run brew upgrade ..."
brew upgrade
brew bundle
brew cleanup

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
exec $SHELL -l

# config
mkdir -p $HOME/.config/gh & ln -s $HOME/dotfiles/gh/config.yml $HOME/.config/gh/config.yml

