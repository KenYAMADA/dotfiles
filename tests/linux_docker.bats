#!/usr/bin/env bats
# Linux integration tests using Docker.
# Requires Docker to be running. Skipped automatically if Docker is unavailable.

DOTFILES="$BATS_TEST_DIRNAME/.."
DOCKER_DIR="$BATS_TEST_DIRNAME/docker"

setup_file() {
  if ! command -v docker &> /dev/null || ! docker info &> /dev/null 2>&1; then
    skip "Docker is not available"
  fi

  echo "Building Docker test images..." >&3
  docker build -q -t dotfiles-test-ubuntu -f "$DOCKER_DIR/Dockerfile.ubuntu" "$DOCKER_DIR" >&3
  docker build -q -t dotfiles-test-fedora -f "$DOCKER_DIR/Dockerfile.fedora" "$DOCKER_DIR" >&3
}

_run_in_container() {
  local image="$1"
  shift
  docker run --rm \
    -v "$DOTFILES:/home/testuser/dotfiles:ro" \
    "$image" \
    "$@"
}

# ── Ubuntu tests ──────────────────────────────────────────────────────────────

@test "[ubuntu] zsh is installed" {
  if ! docker info &>/dev/null 2>&1; then skip "Docker unavailable"; fi
  run _run_in_container dotfiles-test-ubuntu which zsh
  [ "$status" -eq 0 ]
  [[ "$output" == */zsh ]]
}

@test "[ubuntu] zsh is in /etc/shells" {
  if ! docker info &>/dev/null 2>&1; then skip "Docker unavailable"; fi
  run _run_in_container dotfiles-test-ubuntu grep -q zsh /etc/shells
  [ "$status" -eq 0 ]
}

@test "[ubuntu] .zshenv syntax is valid" {
  if ! docker info &>/dev/null 2>&1; then skip "Docker unavailable"; fi
  run _run_in_container dotfiles-test-ubuntu \
    zsh -n /home/testuser/dotfiles/.zshenv
  [ "$status" -eq 0 ]
}

@test "[ubuntu] .zshrc syntax is valid" {
  if ! docker info &>/dev/null 2>&1; then skip "Docker unavailable"; fi
  run _run_in_container dotfiles-test-ubuntu \
    zsh -n /home/testuser/dotfiles/.zshrc
  [ "$status" -eq 0 ]
}

@test "[ubuntu] XDG variables are set correctly" {
  if ! docker info &>/dev/null 2>&1; then skip "Docker unavailable"; fi
  run _run_in_container dotfiles-test-ubuntu \
    zsh -c "source /home/testuser/dotfiles/.zshenv && \
            echo XDG_CONFIG_HOME=\$XDG_CONFIG_HOME && \
            echo XDG_DATA_HOME=\$XDG_DATA_HOME && \
            echo XDG_STATE_HOME=\$XDG_STATE_HOME"
  [ "$status" -eq 0 ]
  [[ "$output" == *"XDG_CONFIG_HOME=/home/testuser/.config"* ]]
  [[ "$output" == *"XDG_DATA_HOME=/home/testuser/.local/share"* ]]
  [[ "$output" == *"XDG_STATE_HOME=/home/testuser/.local/state"* ]]
}

@test "[ubuntu] ZDOTDIR points to ~/.config/zsh" {
  if ! docker info &>/dev/null 2>&1; then skip "Docker unavailable"; fi
  run _run_in_container dotfiles-test-ubuntu \
    zsh -c "source /home/testuser/dotfiles/.zshenv && echo \$ZDOTDIR"
  [ "$status" -eq 0 ]
  [ "$output" = "/home/testuser/.config/zsh" ]
}

@test "[ubuntu] HISTFILE points to XDG state dir" {
  if ! docker info &>/dev/null 2>&1; then skip "Docker unavailable"; fi
  run _run_in_container dotfiles-test-ubuntu \
    zsh -c "source /home/testuser/dotfiles/.zshenv && echo \$HISTFILE"
  [ "$status" -eq 0 ]
  [ "$output" = "/home/testuser/.local/state/zsh/history" ]
}

@test "[ubuntu] full setup: symlinks and XDG checks pass" {
  if ! docker info &>/dev/null 2>&1; then skip "Docker unavailable"; fi
  run _run_in_container dotfiles-test-ubuntu \
    zsh /home/testuser/dotfiles/tests/docker/test_setup.sh
  [ "$status" -eq 0 ]
}

# ── Fedora tests ──────────────────────────────────────────────────────────────

@test "[fedora] zsh is installed" {
  if ! docker info &>/dev/null 2>&1; then skip "Docker unavailable"; fi
  run _run_in_container dotfiles-test-fedora which zsh
  [ "$status" -eq 0 ]
  [[ "$output" == */zsh ]]
}

@test "[fedora] .zshenv syntax is valid" {
  if ! docker info &>/dev/null 2>&1; then skip "Docker unavailable"; fi
  run _run_in_container dotfiles-test-fedora \
    zsh -n /home/testuser/dotfiles/.zshenv
  [ "$status" -eq 0 ]
}

@test "[fedora] XDG variables are set correctly" {
  if ! docker info &>/dev/null 2>&1; then skip "Docker unavailable"; fi
  run _run_in_container dotfiles-test-fedora \
    zsh -c "source /home/testuser/dotfiles/.zshenv && \
            echo XDG_CONFIG_HOME=\$XDG_CONFIG_HOME && \
            echo XDG_DATA_HOME=\$XDG_DATA_HOME"
  [ "$status" -eq 0 ]
  [[ "$output" == *"XDG_CONFIG_HOME=/home/testuser/.config"* ]]
  [[ "$output" == *"XDG_DATA_HOME=/home/testuser/.local/share"* ]]
}

@test "[fedora] full setup: symlinks and XDG checks pass" {
  if ! docker info &>/dev/null 2>&1; then skip "Docker unavailable"; fi
  run _run_in_container dotfiles-test-fedora \
    zsh /home/testuser/dotfiles/tests/docker/test_setup.sh
  [ "$status" -eq 0 ]
}
