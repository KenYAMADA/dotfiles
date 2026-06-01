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

# anyenv update plugins (XDG: ~/.local/share/anyenv)
_ANYENV_ROOT="${ANYENV_ROOT:-$HOME/.local/share/anyenv}"
mkdir -p "$_ANYENV_ROOT/plugins"
if [ ! -d "$_ANYENV_ROOT/plugins/anyenv-update" ]; then
    echo "Cloning anyenv-update plugin..."
    git clone https://github.com/znz/anyenv-update.git "$_ANYENV_ROOT/plugins/anyenv-update"
else
    echo "anyenv-update plugin already exists. Skipping clone."
fi
unset _ANYENV_ROOT

# config
mkdir -p $HOME/.config/gh && ln -snf $HOME/dotfiles/gh/config.yml $HOME/.config/gh/config.yml

# Remove legacy ~/.p10k.zsh if it exists (now managed as symlink via setup.sh)
if [ -f "$HOME/.p10k.zsh" ] && [ ! -L "$HOME/.p10k.zsh" ]; then
    echo "Removing legacy ~/.p10k.zsh (p10k config is now at ~/.config/p10k.zsh)"
    rm "$HOME/.p10k.zsh"
fi

## Google Cloud SDK setup
echo "Setting up Google Cloud SDK..."
if [ ! -x "$DOTPATH/scripts/setup_gcloud.sh" ]; then
    chmod +x "$DOTPATH/scripts/setup_gcloud.sh"
fi
bash "$DOTPATH/scripts/setup_gcloud.sh"

## Heroku CLI is now managed by a separate script.
## To install it, run:
## bash ~/dotfiles/scripts/setup_heroku.sh

## Font configuration is now managed by separate scripts.
## To set up fonts, run:
## bash ~/dotfiles/scripts/setup_vscode_fonts.sh
## bash ~/dotfiles/scripts/setup_cursor_fonts.sh
## bash ~/dotfiles/scripts/setup_windsurf_fonts.sh
## bash ~/dotfiles/scripts/setup_terminal_fonts.sh
## bash ~/dotfiles/scripts/setup_iterm2_profile.sh
