#!/bin/bash

DOTPATH=$HOME/dotfiles
DOT_FILES=(.zshrc .zshenv .vimrc)

for file in ${DOT_FILES[@]}
do
  ln -sf $DOTPATH/$file $HOME/$file
  if [ $? -eq 0 ]; then
    printf "    %-25s -> %s\n" "\$DOTPATH/$file" "\$HOME/$file"
  fi   
done

case ${OSTYPE} in
  darwin*)
    # Mac用の設定
    ## iTerm shell integration 
    ## https://iterm2.com/documentation-shell-integration.html
    ## https://www.rasukarusan.com/entry/2019/04/13/180443
    curl -L https://iterm2.com/misc/install_shell_integration.sh | bash
    ;;
  linux*)
    # Linux用の設定
    ;;
esac

