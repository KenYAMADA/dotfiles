#!/bin/bash

DOTPATH=$HOME/dotfiles
DOT_FILES=(.bin .zshrc .zshenv .vimrc)

## zsh setup
case ${OSTYPE} in
  darwin*)
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

    # Mac用の設定
    ## .DS_Storeを作成しない。
    defaults write com.apple.desktopservices DSDontWriteNetworkStores True
    ## screenshot
    defaults write com.apple.screencapture name "ss"
    mkdir $HOME/Pictures/ScreenShots/
    defaults write com.apple.screencapture location $HOME/Pictures/ScreenShots/
    defaults write com.apple.dock springboard-columns -int 10
    defaults write com.apple.dock springboard-rows -int 6
    defaults write com.apple.dock ResetLaunchPad -bool TRUE
    killall Dock
    ;;
  Linux*)
    sudo apt update
    sudo apt upgrade -y
    sudo apt dist-update -y
    sudo apt install zsh -y
    chsh -s /bin/zsh 
    ;;
esac

## Oh my zsh install
## https://ohmyz.sh/
echo 'Oh! my zsh install...'
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions

## dotfile
for file in ${DOT_FILES[@]}
do
  mv $HOME/$file $HOME/$file.org
  ln -sf $DOTPATH/$file $HOME/$file
  if [ $? -eq 0 ]; then
    printf "    %-25s -> %s\n" "\$DOTPATH/$file" "\$HOME/$file"
  fi   
done

## anyenv install
git clone https://github.com/anyenv/anyenv ~/.anyenv
anyenv install --init

case ${OSTYPE} in
  darwin*)
    ## mac packege init
    bash $DOTPATH/mac_init.sh
    ;;
  linux*)
    # Linux package init
    bash $DOTPATH/apt_init.sh
    ;;
esac

exec $SHELL -l

# Google Cloud SDK install
# https://cloud.google.com/sdk/docs/downloads-interactive?hl=ja#interactive_installation
#curl https://sdk.cloud.google.com | bash

# Firebase CLI
# https://firebase.google.com/docs/cli#windows-standalone-binary
## node環境に入れる 
## npm install -g firebase-tools
