#!/bin/bash

if [ "$(uname)" != "Darwin" ] ; then
	echo "Not macOS!"
	exit 1
fi

# macOS settings
## Do not create .DS_Store files.
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

## vim plugin
if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

# anyenv plugins are typically initialized by 'anyenv install --init' in setup.sh.
# If you need to install additional specific plugins, uncomment and add them here.
# anyenv install rbenv
# anyenv install pyenv
# anyenv install nodenv
# anyenv install goenv
# anyenv install jenv

# anyenv update plugins
mkdir -p $(anyenv root)/plugins
if [ ! -d "$(anyenv root)/plugins/anyenv-update" ]; then
    echo "Cloning anyenv-update plugin..."
    git clone https://github.com/znz/anyenv-update.git $(anyenv root)/plugins/anyenv-update
else
    echo "anyenv-update plugin already exists. Skipping clone."
fi

# config
mkdir -p $HOME/.config/gh && ln -snf $HOME/dotfiles/gh/config.yml $HOME/.config/gh/config.yml

## Heroku CLI is now managed by a separate script.
## To install it, run:
## bash ~/dotfiles/scripts/setup_heroku.sh
