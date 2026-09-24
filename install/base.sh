#!/usr/bin/env bash

# Install the foundational Arch packages from packages/base.txt.
# Run this first after the initial Arch installation.
set -euo pipefail

source "$(dirname "$0")/_lib.sh"

# Fully update the fresh system before adding packages.
sudo pacman -Syu

# Kernel, firmware, networking/audio basics, development tools and filesystems.
install_manifest "$ROOT/packages/base.txt"
