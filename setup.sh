#!/bin/bash

DOTPATH=$HOME/dotfiles
DOT_FILES=(.bin .zshrc .zshenv .vimrc)

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
    ## Google SQL Auth Proxy
    ## https://cloud.google.com/sql/docs/mysql/sql-proxy?hl=ja#install
    curl -o ~/.bin/cloud_sql_proxy https://dl.google.com/cloudsql/cloud_sql_proxy.darwin.amd64
    chmod +x ~/.bin/cloud_sql_proxy
    ;;
  linux*)
    # Linux用の設定
    ;;
esac

