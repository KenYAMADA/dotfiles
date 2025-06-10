export PATH=$HOME/.bin:/usr/local/bin:$PATH

test -e "$HOME/.iterm2_shell_integration.zsh" && source "$HOME/.iterm2_shell_integration.zsh"

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin


# alias
source ~/dotfiles/.zshrc.alias

# Options
setopt print_eight_bit  # 日本語ファイル名を表示可能にする
setopt no_flow_control  # フローコントロールを無効にする
setopt interactive_comments  # '#' 以降をコメントとして扱う
setopt auto_cd  # ディレクトリ名だけでcdする
setopt share_history  # 同時に起動したzshの間でヒストリを共有する
setopt hist_ignore_all_dups  # 同じコマンドをヒストリに残さない
setopt hist_ignore_space  # スペースから始まるコマンド行はヒストリに残さない
setopt hist_reduce_blanks  # ヒストリに保存するときに余分なスペースを削除する

########################################
# OS 別の設定
case ${OSTYPE} in
    darwin*)
        #Mac用の設定
        export CLICOLOR=1
        alias ls='ls -G -F'
        ;;
    linux*)
        #Linux用の設定
        alias ls='ls -F --color=auto'
        ;;
esac

## Java
#case ${OSTYPE} in
#  darwin*)
#    export JAVA_HOME=`/usr/libexec/java_home -v "17"`
#    ;;
#  Linux*)
#    ;;
#esac

## anyenv
if [ -e "$HOME/.anyenv" ]
then
    export ANYENV_ROOT="$HOME/.anyenv"
    export PATH="$ANYENV_ROOT/bin:$PATH"
    if command -v anyenv 1>/dev/null 2>&1
    then
        eval "$(anyenv init -)"
    fi
fi

## Rust
if [ -e "$HOME/.cargo/bin" ]
then
  export PATH=$HOME/.cargo/bin:$PATH
fi

## Flutter
if [ -e "$HOME/development/flutter/bin" ]
then
  export PATH=$HOME/development/flutter/bin:$PATH
fi
export PATH="$PATH":"$HOME/.pub-cache/bin"

## mysql client
if [ -e "/usr/local/opt/mysql-client/bin/bin" ]
then
  export PATH=/usr/local/opt/mysql-client/bin:$PATH
fi

## Android SDK
if [ -e "$HOME/Library/Android/sdk" ]
then
  export ANDROID_HOME=$HOME/Library/Android/sdk
  export PATH=$ANDROID_HOME/tools/bin/sdkmanager:$ANDROID_HOME/tools/bin/avdmanager:$PATH
fi

export PATH=~/.local/bin:$PATH
