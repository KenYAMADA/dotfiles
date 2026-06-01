#!/bin/zsh
# Runs inside the Docker container to verify dotfiles setup.
# Exit code 0 = all checks passed.

set -e

DOTPATH="$HOME/dotfiles"
PASS=0
FAIL=0

check() {
  local desc="$1"
  local result="$2"
  if [ "$result" = "ok" ]; then
    echo "  PASS: $desc"
    PASS=$((PASS + 1))
  else
    echo "  FAIL: $desc ($result)"
    FAIL=$((FAIL + 1))
  fi
}

# --- Run setup (symlinks only, skip package install and Oh My Zsh) ---
mkdir -p "$HOME/.local/state/zsh"
mkdir -p "$HOME/.config/zsh"
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.claude"

ln -snf "$DOTPATH/.zshrc"        "$HOME/.config/zsh/.zshrc"
ln -snf "$DOTPATH/.zshenv"       "$HOME/.zshenv"
ln -snf "$DOTPATH/.vimrc"        "$HOME/.vimrc"
ln -snf "$DOTPATH/p10k.zsh"      "$HOME/.config/p10k.zsh"
for f in settings.json CLAUDE.md RTK.md statusline.sh; do
  ln -snf "$DOTPATH/claude/$f"   "$HOME/.claude/$f"
done

# --- Symlink checks ---
check "~/.zshenv is symlink"             "$([ -L "$HOME/.zshenv" ] && echo ok || echo 'not a symlink')"
check "~/.config/zsh/.zshrc is symlink"  "$([ -L "$HOME/.config/zsh/.zshrc" ] && echo ok || echo 'not a symlink')"
check "~/.config/p10k.zsh is symlink"    "$([ -L "$HOME/.config/p10k.zsh" ] && echo ok || echo 'not a symlink')"
check "~/.claude/settings.json is symlink" "$([ -L "$HOME/.claude/settings.json" ] && echo ok || echo 'not a symlink')"
check "~/.local/state/zsh dir exists"    "$([ -d "$HOME/.local/state/zsh" ] && echo ok || echo 'missing')"

# --- XDG variable checks (source .zshenv in zsh) ---
xdg_config=$(zsh -c "source $HOME/.zshenv; echo \$XDG_CONFIG_HOME")
xdg_data=$(zsh   -c "source $HOME/.zshenv; echo \$XDG_DATA_HOME")
xdg_state=$(zsh  -c "source $HOME/.zshenv; echo \$XDG_STATE_HOME")
zdotdir=$(zsh    -c "source $HOME/.zshenv; echo \$ZDOTDIR")
histfile=$(zsh   -c "source $HOME/.zshenv; echo \$HISTFILE")
dotpath=$(zsh    -c "source $HOME/.zshenv; echo \$DOTPATH")

check "XDG_CONFIG_HOME = ~/.config"             "$([ "$xdg_config" = "$HOME/.config" ] && echo ok || echo "got: $xdg_config")"
check "XDG_DATA_HOME = ~/.local/share"          "$([ "$xdg_data" = "$HOME/.local/share" ] && echo ok || echo "got: $xdg_data")"
check "XDG_STATE_HOME = ~/.local/state"         "$([ "$xdg_state" = "$HOME/.local/state" ] && echo ok || echo "got: $xdg_state")"
check "ZDOTDIR = ~/.config/zsh"                 "$([ "$zdotdir" = "$HOME/.config/zsh" ] && echo ok || echo "got: $zdotdir")"
check "HISTFILE = ~/.local/state/zsh/history"   "$([ "$histfile" = "$HOME/.local/state/zsh/history" ] && echo ok || echo "got: $histfile")"
check "DOTPATH = ~/dotfiles"                    "$([ "$dotpath" = "$HOME/dotfiles" ] && echo ok || echo "got: $dotpath")"

# --- Syntax checks ---
check ".zshenv syntax"     "$(zsh -n "$DOTPATH/.zshenv" 2>&1 && echo ok || echo 'syntax error')"
check ".zshrc syntax"      "$(zsh -n "$DOTPATH/.zshrc"  2>&1 && echo ok || echo 'syntax error')"

# --- zsh availability ---
check "zsh is installed"   "$(command -v zsh >/dev/null && echo ok || echo 'not found')"
check "zsh in /etc/shells" "$(grep -q zsh /etc/shells && echo ok || echo 'not in /etc/shells')"

# --- Summary ---
echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
