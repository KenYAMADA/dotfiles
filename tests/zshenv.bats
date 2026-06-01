#!/usr/bin/env bats
# Tests for .zshenv: XDG variables, PATH, environment settings

DOTFILES="$BATS_TEST_DIRNAME/.."

setup() {
  export HOME="$BATS_TMPDIR/home"
  mkdir -p "$HOME"
  unset XDG_CONFIG_HOME XDG_DATA_HOME XDG_STATE_HOME XDG_CACHE_HOME
  unset ZDOTDIR DOTPATH ZSH ANYENV_ROOT HISTFILE
}

@test ".zshenv has no syntax errors" {
  run zsh -n "$DOTFILES/.zshenv"
  [ "$status" -eq 0 ]
}

@test "XDG_CONFIG_HOME defaults to ~/.config" {
  run zsh -c "HOME='$HOME'; source '$DOTFILES/.zshenv'; echo \$XDG_CONFIG_HOME"
  [ "$status" -eq 0 ]
  [ "$output" = "$HOME/.config" ]
}

@test "XDG_DATA_HOME defaults to ~/.local/share" {
  run zsh -c "HOME='$HOME'; source '$DOTFILES/.zshenv'; echo \$XDG_DATA_HOME"
  [ "$status" -eq 0 ]
  [ "$output" = "$HOME/.local/share" ]
}

@test "XDG_STATE_HOME defaults to ~/.local/state" {
  run zsh -c "HOME='$HOME'; source '$DOTFILES/.zshenv'; echo \$XDG_STATE_HOME"
  [ "$status" -eq 0 ]
  [ "$output" = "$HOME/.local/state" ]
}

@test "XDG_CACHE_HOME defaults to ~/.cache" {
  run zsh -c "HOME='$HOME'; source '$DOTFILES/.zshenv'; echo \$XDG_CACHE_HOME"
  [ "$status" -eq 0 ]
  [ "$output" = "$HOME/.cache" ]
}

@test "ZDOTDIR is set to XDG_CONFIG_HOME/zsh" {
  run zsh -c "HOME='$HOME'; source '$DOTFILES/.zshenv'; echo \$ZDOTDIR"
  [ "$status" -eq 0 ]
  [ "$output" = "$HOME/.config/zsh" ]
}

@test "DOTPATH is set to ~/dotfiles" {
  run zsh -c "HOME='$HOME'; source '$DOTFILES/.zshenv'; echo \$DOTPATH"
  [ "$status" -eq 0 ]
  [ "$output" = "$HOME/dotfiles" ]
}

@test "ZSH is set to XDG_DATA_HOME/oh-my-zsh" {
  run zsh -c "HOME='$HOME'; source '$DOTFILES/.zshenv'; echo \$ZSH"
  [ "$status" -eq 0 ]
  [ "$output" = "$HOME/.local/share/oh-my-zsh" ]
}

@test "ANYENV_ROOT is set to XDG_DATA_HOME/anyenv" {
  run zsh -c "HOME='$HOME'; source '$DOTFILES/.zshenv'; echo \$ANYENV_ROOT"
  [ "$status" -eq 0 ]
  [ "$output" = "$HOME/.local/share/anyenv" ]
}

@test "HISTFILE is set to XDG_STATE_HOME/zsh/history" {
  run zsh -c "HOME='$HOME'; source '$DOTFILES/.zshenv'; echo \$HISTFILE"
  [ "$status" -eq 0 ]
  [ "$output" = "$HOME/.local/state/zsh/history" ]
}

@test "existing XDG_CONFIG_HOME is not overridden" {
  run zsh -c "HOME='$HOME'; XDG_CONFIG_HOME='/custom/config'; source '$DOTFILES/.zshenv'; echo \$XDG_CONFIG_HOME"
  [ "$status" -eq 0 ]
  [ "$output" = "/custom/config" ]
}

@test "PATH includes ~/.bin" {
  run zsh -c "HOME='$HOME'; source '$DOTFILES/.zshenv'; echo \$PATH"
  [ "$status" -eq 0 ]
  [[ "$output" == *"$HOME/.bin"* ]]
}

@test "PATH includes ~/.local/bin" {
  run zsh -c "HOME='$HOME'; source '$DOTFILES/.zshenv'; echo \$PATH"
  [ "$status" -eq 0 ]
  [[ "$output" == *"$HOME/.local/bin"* ]]
}
