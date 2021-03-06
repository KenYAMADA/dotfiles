# 環境変数
export LANG=ja_JP.UTF-8

## iTerm shell integration
## https://iterm2.com/documentation-shell-integration.html
test -e "$HOME/.iterm2_shell_integration.zsh" && source "$HOME/.iterm2_shell_integration.zsh"

# 色を使用出来るようにする
autoload -Uz colors
colors

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000


# プロンプト
# 1行表示
# PROMPT="%~ %# "
# 2行表示
PROMPT="%{${fg[green]}%}[%n@%m]%{${reset_color}%} %~
%# "

export PATH="/usr/local/sbin:$PATH"

##########
# 補完機能を有効にする
# % brew install zsh-completions
autoload -Uz compinit
compinit

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

fpath=(/usr/local/share/zsh-completions $fpath)
fpath=(/usr/local/share/zsh/site-functions $fpath)

# コマンドの自動サジェスト機能
# % brew install zsh-autosuggestions
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# コマンドのシンタックスハイライト機能
# % brew install zsh-syntax-highlighting
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

###########
# vcs_info
autoload -Uz vcs_info
autoload -Uz add-zsh-hook

zstyle ':vcs_info:*' formats '%F{green}(%s)-[%b]%f'
zstyle ':vcs_info:*' actionformats '%F{red}(%s)-[%b|%a]%f'

function _update_vcs_info_msg() {
    LANG=en_US.UTF-8 vcs_info
    RPROMPT="${vcs_info_msg_0_}"
}
add-zsh-hook precmd _update_vcs_info_msg

###########
# Options

setopt print_eight_bit  # 日本語ファイル名を表示可能にする
setopt no_flow_control  # フローコントロールを無効にする
setopt interactive_comments  # '#' 以降をコメントとして扱う
setopt auto_cd  # ディレクトリ名だけでcdする
setopt share_history  # 同時に起動したzshの間でヒストリを共有する
setopt hist_ignore_all_dups  # 同じコマンドをヒストリに残さない
setopt hist_ignore_space  # スペースから始まるコマンド行はヒストリに残さない
setopt hist_reduce_blanks  # ヒストリに保存するときに余分なスペースを削除する

##########
# Aliases

# https://www.task-notes.com/entry/20141223/1419324649
alias brew="env PATH=${PATH/~\/\.pyenv\/shims:/} brew"

# https://wonderwall.hatenablog.com/entry/2017/08/07/222350
alias ls='exa'
alias ll='exa -hl --git'
alias la='exa -ahl --git'

alias vi='vim'

# Always enable colored `grep` output
# Note: `GREP_OPTIONS="--color=auto"` is deprecated, hence the alias usage.
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias mkdir='mkdir -p'

# Easier navigation: .., ..., ...., .....
alias ..="cd .."

# sudo の後のコマンドでエイリアスを有効にする
alias sudo='sudo '

# グローバルエイリアス
alias -g ...="cd ../.."
alias -g C='| wc -l'
alias -g G='| egrep'
alias -g L='| less'
alias -g S='| sort'
alias -g T='| tail'
alias -g X='| xargs'

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
export JAVA_HOME=`/usr/libexec/java_home -v 11`

## pyenv
export PYENV_ROOT=$HOME/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH
eval "$(pyenv init --path)"

## nodenv
export NODE_ROOT=$HOME/.nodenv
export PATH=$NODE_ROOT/bin:$PATH
eval "$(nodenv init -)"

## goenv
export GOENV_ROOT=$HOME/.goenv
export PATH=$GOENV_ROOT/bin:$PATH
eval "$(goenv init -)"

## Rust
export PATH=$HOME/.cargo/bin:$PATH

## Flutter
export PATH=$HOME/development/flutter/bin:$PATH

## mysql client
export PATH=/usr/local/opt/mysql-client/bin:$PATH

## Android SDK
export PATH=$HOME/Library/Android/sdk/platform-tools:$PATH

## オレオレ
export PATH=$HOME/.bin:$PATH

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/yamadaken/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/yamadaken/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/yamadaken/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/yamadaken/google-cloud-sdk/completion.zsh.inc'; fi
