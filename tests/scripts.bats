#!/usr/bin/env bats
# Syntax checks and file existence tests for scripts and config files

DOTFILES="$BATS_TEST_DIRNAME/.."

@test "mac_init.sh has no syntax errors" {
  run bash -n "$DOTFILES/mac_init.sh"
  [ "$status" -eq 0 ]
}

@test "linux_init.sh has no syntax errors" {
  run bash -n "$DOTFILES/linux_init.sh"
  [ "$status" -eq 0 ]
}

@test "scripts/setup_zsh.sh has no syntax errors" {
  run bash -n "$DOTFILES/scripts/setup_zsh.sh"
  [ "$status" -eq 0 ]
}

@test "scripts/setup_claude_code.sh has no syntax errors" {
  run bash -n "$DOTFILES/scripts/setup_claude_code.sh"
  [ "$status" -eq 0 ]
}

@test "scripts/setup_android.sh has no syntax errors" {
  run bash -n "$DOTFILES/scripts/setup_android.sh"
  [ "$status" -eq 0 ]
}

@test "scripts/setup_gcloud.sh has no syntax errors" {
  run bash -n "$DOTFILES/scripts/setup_gcloud.sh"
  [ "$status" -eq 0 ]
}

@test "scripts/setup_aws.sh has no syntax errors" {
  run bash -n "$DOTFILES/scripts/setup_aws.sh"
  [ "$status" -eq 0 ]
}

@test ".zshrc has no syntax errors" {
  run zsh -n "$DOTFILES/.zshrc"
  [ "$status" -eq 0 ]
}

@test ".zshrc.alias has no syntax errors" {
  run zsh -n "$DOTFILES/.zshrc.alias"
  [ "$status" -eq 0 ]
}

@test "p10k.zsh has no syntax errors" {
  run zsh -n "$DOTFILES/p10k.zsh"
  [ "$status" -eq 0 ]
}

@test "claude/settings.json is valid JSON" {
  run python3 -c "import json,sys; json.load(open('$DOTFILES/claude/settings.json'))"
  [ "$status" -eq 0 ]
}

@test "claude/statusline.sh has no syntax errors" {
  run bash -n "$DOTFILES/claude/statusline.sh"
  [ "$status" -eq 0 ]
}

@test "starship.toml exists" {
  [ -f "$DOTFILES/starship.toml" ]
}

@test "Brewfile exists" {
  [ -f "$DOTFILES/Brewfile" ]
}

@test "packages/apt.txt includes zsh" {
  run grep -x "zsh" "$DOTFILES/packages/apt.txt"
  [ "$status" -eq 0 ]
}

@test "packages/dnf.txt includes zsh" {
  run grep -x "zsh" "$DOTFILES/packages/dnf.txt"
  [ "$status" -eq 0 ]
}

@test "packages/pacman.txt includes zsh" {
  run grep -x "zsh" "$DOTFILES/packages/pacman.txt"
  [ "$status" -eq 0 ]
}
