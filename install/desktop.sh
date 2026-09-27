#!/usr/bin/env bash

# Install the everyday Niri + Noctalia desktop stack.
# Packages are kept in packages/desktop.txt so they are easy to audit.
set -euo pipefail

source "$(dirname "$0")/_lib.sh"

# Steam and the 32-bit Mesa/Vulkan libraries require Arch's multilib repo.
if ! grep -Eq '^[[:space:]]*\[multilib\][[:space:]]*$' /etc/pacman.conf; then
  echo "error: enable [multilib] before installing the desktop manifest (Steam/lib32)." >&2
  exit 1
fi

# Prefer these concrete providers for virtual dependencies. install_manifest
# checks each name first; if Arch renames/removes one, it is omitted and pacman
# falls back to its normal interactive provider prompt instead of aborting.
install_manifest "$ROOT/packages/desktop.txt" \
  pipewire-jack \
  qt6-multimedia-ffmpeg

# Fish is installed here, but changing the login shell is intentionally left
# as an explicit user action rather than silently modifying the account.
if command -v fish >/dev/null && [[ "$SHELL" != "/usr/bin/fish" ]]; then
  echo
  echo "Fish is installed. To make it your login shell:"
  echo "  chsh -s /usr/bin/fish"
fi
