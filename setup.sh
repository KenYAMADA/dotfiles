#!/bin/bash

DOTPATH=$HOME/dotfiles
DOT_FILES=(.bin .zshrc .zshenv .vimrc)

for file in ${DOT_FILES[@]}
do
  mv $HOME/$file $HOME/$file.org
  ln -sf $DOTPATH/$file $HOME/$file
  if [ $? -eq 0 ]; then
    printf "    %-25s -> %s\n" "\$DOTPATH/$file" "\$HOME/$file"
  fi   
done

## anyenv setting
git clone https://github.com/anyenv/anyenv ~/.anyenv

case ${OSTYPE} in
  darwin*)
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
    ## mac packege init
    bash $DOTPATH/mac_init.sh
    ;;
  linux*)
    # Linux用の設定
    ;;
esac

# Google Cloud SDK install
# https://cloud.google.com/sdk/docs/downloads-interactive?hl=ja#interactive_installation
#curl https://sdk.cloud.google.com | bash

# Firebase CLI
# https://firebase.google.com/docs/cli#windows-standalone-binary
## node環境に入れる 
## npm install -g firebase-tools
