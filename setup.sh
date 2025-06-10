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
    echo "run brew update & upgrade ..."
    brew update && brew upgrade
    
    echo "Installing packages from Brewfile..."
    brew bundle --file="$DOTPATH/Brewfile" # Brewfileのパスを明示
    brew cleanup
    ;;
  Linux*)
    echo "Updating apt..."
    sudo apt update && sudo apt upgrade -y
    
    echo "Installing packages from apt_packages.txt..."
    # xargsで空白行を無視し、コメント(#)を許可する
    grep -v '^#' "$DOTPATH/apt_packages.txt" | grep -v '^$' | xargs sudo apt install -y
    
    echo "Set zsh"
    chsh -s /bin/zsh
    ;;
esac

## Oh my zsh install
## https://ohmyz.sh/
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo 'Oh! my zsh install...'
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions

## dotfile
for file in ${DOT_FILES[@]}
do
  # バックアップ処理を改善
  if [ -e "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
    mv "$HOME/$file" "$HOME/$file.org"
  fi
  ln -snf "$DOTPATH/$file" "$HOME/$file"
  if [ $? -eq 0 ]; then
    printf "    %-25s -> %s\n" "$DOTPATH/$file" "$HOME/$file"
  fi   
done

## anyenv install
if [ ! -d "$HOME/.anyenv" ]; then
    git clone https://github.com/anyenv/anyenv ~/.anyenv
    anyenv install --init
fi

## Platform specific init
case ${OSTYPE} in
  darwin*)
    bash $DOTPATH/mac_init.sh
    ;;
  linux*)
    bash $DOTPATH/apt_init.sh
    ;;
esac

exec $SHELL -l

