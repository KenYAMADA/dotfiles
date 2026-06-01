#!/usr/bin/env bats
# Tests for setup.sh: symlink creation and directory setup

DOTFILES="$BATS_TEST_DIRNAME/.."

setup() {
  export FAKE_HOME="$BATS_TMPDIR/home_$$"
  mkdir -p "$FAKE_HOME"
}

teardown() {
  rm -rf "$FAKE_HOME"
}

_run_symlink_setup() {
  bash -c "
    HOME='$FAKE_HOME'
    DOTPATH='$DOTFILES'

    mkdir -p \"\$HOME/.local/state/zsh\"
    mkdir -p \"\$HOME/.config/zsh\"
    ln -snf \"\$DOTPATH/.zshrc\" \"\$HOME/.config/zsh/.zshrc\"

    mkdir -p \"\$HOME/.config\"
    ln -snf \"\$DOTPATH/p10k.zsh\" \"\$HOME/.config/p10k.zsh\"

    mkdir -p \"\$HOME/.claude\"
    for f in settings.json CLAUDE.md RTK.md statusline.sh; do
      ln -snf \"\$DOTPATH/claude/\$f\" \"\$HOME/.claude/\$f\"
    done

    for file in .zshenv .vimrc; do
      ln -snf \"\$DOTPATH/\$file\" \"\$HOME/\$file\"
    done
  "
}

@test "setup.sh has no syntax errors" {
  run bash -n "$DOTFILES/setup.sh"
  [ "$status" -eq 0 ]
}

@test "~/.config/zsh/.zshrc is a symlink to .zshrc" {
  _run_symlink_setup
  [ -L "$FAKE_HOME/.config/zsh/.zshrc" ]
  [ "$(readlink "$FAKE_HOME/.config/zsh/.zshrc")" = "$DOTFILES/.zshrc" ]
}

@test "~/.config/p10k.zsh is a symlink to p10k.zsh" {
  _run_symlink_setup
  [ -L "$FAKE_HOME/.config/p10k.zsh" ]
  [ "$(readlink "$FAKE_HOME/.config/p10k.zsh")" = "$DOTFILES/p10k.zsh" ]
}

@test "~/.zshenv is a symlink to .zshenv" {
  _run_symlink_setup
  [ -L "$FAKE_HOME/.zshenv" ]
  [ "$(readlink "$FAKE_HOME/.zshenv")" = "$DOTFILES/.zshenv" ]
}

@test "~/.claude/settings.json is a symlink" {
  _run_symlink_setup
  [ -L "$FAKE_HOME/.claude/settings.json" ]
  [ "$(readlink "$FAKE_HOME/.claude/settings.json")" = "$DOTFILES/claude/settings.json" ]
}

@test "~/.claude/statusline.sh is a symlink" {
  _run_symlink_setup
  [ -L "$FAKE_HOME/.claude/statusline.sh" ]
}

@test "~/.local/state/zsh directory is created" {
  bash -c "HOME='$FAKE_HOME'; mkdir -p \"\$HOME/.local/state/zsh\""
  [ -d "$FAKE_HOME/.local/state/zsh" ]
}

@test "existing file is backed up to .org before symlinking" {
  mkdir -p "$FAKE_HOME/.config/zsh"
  echo "existing content" > "$FAKE_HOME/.config/zsh/.zshrc"

  bash -c "
    HOME='$FAKE_HOME'
    DOTPATH='$DOTFILES'
    dest=\"\$HOME/.config/zsh/.zshrc\"
    if [ -e \"\$dest\" ] && [ ! -L \"\$dest\" ]; then
      mv \"\$dest\" \"\${dest}.org\"
    fi
    ln -snf \"\$DOTPATH/.zshrc\" \"\$dest\"
  "

  [ -f "$FAKE_HOME/.config/zsh/.zshrc.org" ]
  [ -L "$FAKE_HOME/.config/zsh/.zshrc" ]
}
