# Bash configuration for Linux
# This file is used when Linux installer is run

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Path configuration
export PATH=$HOME/.bin:/usr/local/bin:$PATH

# History configuration
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

# Append to the history file, don't overwrite it
shopt -s histappend

# Check the window size after each command and update LINES and COLUMNS
shopt -s checkwinsize

# Some Linux terminals start bash with TERM=dumb, which causes prompt tools
# to disable styling. Prefer a safe 256-color terminal type in that case.
if [ -z "$TERM" ] || [ "$TERM" = "dumb" ]; then
    export TERM=xterm-256color
fi

# Detect terminal color support early (avoid monochrome prompt/output)
DOTFILES_HAS_COLOR=0
if [ -t 1 ] && command -v tput > /dev/null 2>&1; then
    TERMINAL_COLORS="$(tput colors 2>/dev/null || echo 0)"
    if [ -n "$TERMINAL_COLORS" ] && [ "$TERMINAL_COLORS" -ge 8 ] 2>/dev/null; then
        DOTFILES_HAS_COLOR=1
    fi
fi

# Prefer color output in common CLIs when supported
if [ "$DOTFILES_HAS_COLOR" -eq 1 ]; then
    unset NO_COLOR
    export CLICOLOR=1
    export CLICOLOR_FORCE=1
    [ -z "$COLORTERM" ] && export COLORTERM=truecolor
fi

# Enable color support for ls/grep
if [ "$DOTFILES_HAS_COLOR" -eq 1 ] && command -v dircolors > /dev/null 2>&1; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Custom aliases
alias ..='cd ..'
alias mkdir='mkdir -p'
alias python='python3'

# Load additional aliases if they exist
if [ -f ~/dotfiles/.bashrc.alias ]; then
    source ~/dotfiles/.bashrc.alias
fi

# Initialize prompt (Starship or fallback)
if command -v starship > /dev/null 2>&1; then
    # Use Starship if available (modern prompt)
    export STARSHIP_CONFIG="${STARSHIP_CONFIG:-$HOME/.config/starship.toml}"
    eval "$(starship init bash)"
else
    # Lightweight fallback prompt for Raspberry Pi and low-resource systems
    echo "Note: Using lightweight prompt (Starship not available)"

    # Git branch function for prompt
    git_branch() {
        local branch
        if command -v git > /dev/null 2>&1 && git rev-parse --git-dir > /dev/null 2>&1; then
            branch=$(git branch 2>/dev/null | grep '^*' | colrm 1 2)
            if [ "$branch" != "" ]; then
                echo " ($branch)"
            fi
        fi
    }

    # Colorful lightweight prompt
    if [ "$DOTFILES_HAS_COLOR" -eq 1 ]; then
        # Colors for the prompt
        RED='\[\033[01;31m\]'
        GREEN='\[\033[01;32m\]'
        YELLOW='\[\033[01;33m\]'
        BLUE='\[\033[01;34m\]'
        PURPLE='\[\033[01;35m\]'
        CYAN='\[\033[01;36m\]'
        WHITE='\[\033[01;37m\]'
        RESET='\[\033[00m\]'

        # Set a readable two-line prompt with git branch
        PS1="${GREEN}\u@\h${RESET} ${BLUE}\w${YELLOW}\$(git_branch)${RESET}\n${CYAN}\\$ ${RESET}"
    else
        # Simple prompt for non-color terminals
        PS1='\u@\h \w\n\$ '
    fi
fi
