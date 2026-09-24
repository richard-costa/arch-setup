#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/_lib.sh"

if ! grep -Eq '^[[:space:]]*\[multilib\][[:space:]]*$' /etc/pacman.conf; then
  echo "error: enable [multilib] before installing the desktop manifest (Steam/lib32)." >&2
  exit 1
fi

install_manifest "$ROOT/packages/desktop.txt"

if command -v fish >/dev/null && [[ "$SHELL" != "/usr/bin/fish" ]]; then
  echo
  echo "Fish is installed. To make it your login shell:"
  echo "  chsh -s /usr/bin/fish"
fi
