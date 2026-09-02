# Google Cloud SDK initialization (must be before instant prompt)
# Check for Homebrew version first, then fallback to manual installation
if [ -f '/opt/homebrew/share/google-cloud-sdk/path.zsh.inc' ]; then
  source '/opt/homebrew/share/google-cloud-sdk/path.zsh.inc'
elif [ -f '/usr/local/share/google-cloud-sdk/path.zsh.inc' ]; then
  source '/usr/local/share/google-cloud-sdk/path.zsh.inc'
elif [ -f '/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc' ]; then
  source '/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
elif [ -f '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc' ]; then
  source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
elif [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then
  source "$HOME/google-cloud-sdk/path.zsh.inc"
fi

if [ -f '/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc' ]; then
  source '/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc'
elif [ -f '/usr/local/share/google-cloud-sdk/completion.zsh.inc' ]; then
  source '/usr/local/share/google-cloud-sdk/completion.zsh.inc'
elif [ -f '/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc' ]; then
  source '/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
elif [ -f '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc' ]; then
  source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
elif [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then
  source "$HOME/google-cloud-sdk/completion.zsh.inc"
fi

# Enable Powerlevel10k instant prompt (macOS only).
if [[ "$OSTYPE" == darwin* ]] && [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Android studio (IntelliJ IDEA) add Env
## https://intellij-support.jetbrains.com/hc/en-us/articles/15268184143890-Shell-Environment-Loading
if [ -z "$INTELLIJ_ENVIRONMENT_READER" ]; then
  export ZSH_TMUX_AUTOSTART=true
fi
# If you come from bash you might have to change your $PATH.
#export PATH=$HOME/.bin:/usr/local/bin:$PATH

# zsh-completions plugin setup
fpath+=${ZSH_CUSTOM:-${ZSH}/custom}/plugins/zsh-completions/src

# Path to your oh-my-zsh installation ($ZSH is set in .zshenv).

# Theme: Powerlevel10k on macOS, none on Linux (Starship handles prompt)
case ${OSTYPE} in
  darwin*)
    ZSH_THEME="powerlevel10k/powerlevel10k"
    ;;
  linux*)
    ZSH_THEME=""
    ;;
esac

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates

# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    zsh-autosuggestions
    zsh-completions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Zsh options
setopt print_eight_bit
setopt no_flow_control
setopt interactive_comments
setopt auto_cd
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks

# sudo 補完
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8
export LANG=ja_JP.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
source "${DOTPATH}/.zshrc.alias"

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=($HOME/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

# Added by LM Studio CLI (lms)
export PATH="$PATH:$HOME/.lmstudio/bin"



[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# To customize prompt, run `p10k configure` or edit ~/.config/p10k.zsh.
case ${OSTYPE} in
  darwin*)
    [[ ! -f "${XDG_CONFIG_HOME}/p10k.zsh" ]] || source "${XDG_CONFIG_HOME}/p10k.zsh"
    ;;
esac

## anyenv
if [ -d "${ANYENV_ROOT}" ]; then
    export PATH="${ANYENV_ROOT}/bin:$PATH"
    if command -v anyenv >/dev/null 2>&1; then
        eval "$(anyenv init - zsh)"
        export ANYENV_DEFINITION_ROOT="${ANYENV_ROOT}/plugins/anyenv-install"
    fi
fi

# Android StudioのJavaを優先（インストール済みの場合のみ）
_AS_JAVA="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
if [ -d "$_AS_JAVA" ]; then
  export JAVA_HOME="$_AS_JAVA"
  export PATH="$JAVA_HOME/bin:$PATH"
fi
unset _AS_JAVA

# asdf
_asdf_sh="$(brew --prefix asdf 2>/dev/null)/libexec/asdf.sh"
[ -f "$_asdf_sh" ] && . "$_asdf_sh"
unset _asdf_sh

# Antigravity
[ -d "$HOME/.antigravity/antigravity/bin" ] && export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# OpenClaw Completion
[[ -f "$HOME/.openclaw/completions/openclaw.zsh" ]] && source "$HOME/.openclaw/completions/openclaw.zsh"

# Starship prompt (Linux)
case ${OSTYPE} in
  linux*)
    command -v starship >/dev/null && eval "$(starship init zsh)"
    ;;
esac

# Local tool integrations
_antigravity_ide_bin="$HOME/.antigravity-ide/antigravity-ide/bin"
[ -d "$_antigravity_ide_bin" ] && export PATH="$_antigravity_ide_bin:$PATH"
unset _antigravity_ide_bin

_local_env="$HOME/.local/bin/env"
[ -f "$_local_env" ] && source "$_local_env"
unset _local_env

_browser_use_bin="$HOME/.browser-use-env/bin"
[ -d "$_browser_use_bin" ] && export PATH="$_browser_use_bin:$PATH"
unset _browser_use_bin
