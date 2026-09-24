#!/usr/bin/env bash

# Deploy portable user configuration with GNU Stow.
#
# --no-folding links individual tracked files instead of replacing whole config
# directories with symlinks. This leaves room for Noctalia-generated files.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if ! command -v stow >/dev/null 2>&1; then
    echo "error: GNU Stow is not installed. Run: bash install/base.sh" >&2
    exit 1
fi

cd "$ROOT/dotfiles"

stow --restow --no-folding --target="$HOME" niri fish kitty

# Noctalia generates these after login/theme changes. Empty placeholders keep
# Niri and Kitty happy before the first generated palette exists.
mkdir -p "$HOME/.config/niri" "$HOME/.config/kitty/themes"
touch "$HOME/.config/niri/noctalia.kdl"
touch "$HOME/.config/kitty/themes/noctalia.conf"

echo "Portable dotfiles deployed."
