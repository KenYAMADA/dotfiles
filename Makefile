DOTFILES := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
.PHONY: test test-unit test-linux docker-build colima-start help

# Run unit tests only (no Docker required)
test-unit:
	bats tests/zshenv.bats tests/setup.bats tests/scripts.bats

# Build Docker test images (requires running Docker daemon)
docker-build:
	docker build -t dotfiles-test-ubuntu -f tests/docker/Dockerfile.ubuntu tests/docker/
	docker build -t dotfiles-test-fedora -f tests/docker/Dockerfile.fedora tests/docker/

# Run Linux Docker tests (requires running Docker daemon)
test-linux: docker-build
	bats tests/linux_docker.bats

# Run all tests
test: test-unit test-linux

# Install and start Colima (lightweight local Docker daemon)
colima-start:
	@command -v colima >/dev/null || bash $(DOTFILES)/scripts/setup_colima.sh
	@colima status 2>/dev/null | grep -q Running || \
	  colima start --arch aarch64 --vm-type vz --vz-rosetta --cpu 4 --memory 8 --disk 60

help:
	@echo "Targets:"
	@echo "  make test-unit     Unit tests only (no Docker)"
	@echo "  make test-linux    Linux Docker tests (needs daemon)"
	@echo "  make test          All tests"
	@echo "  make colima-start  Start Colima as local Docker daemon"
