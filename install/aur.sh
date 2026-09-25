#!/usr/bin/env bash

# Install AUR packages listed in packages/aur.txt.
#
# On a fresh Arch install this script bootstraps yay from the AUR first.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if ! command -v yay >/dev/null 2>&1; then
  echo "yay not found; building it from the AUR..."

  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' EXIT

  git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
  (
    cd "$tmpdir/yay"
    makepkg -si --noconfirm
  )
fi

mapfile -t packages < <(
  sed -E 's/[[:space:]]+#.*$//' "$ROOT/packages/aur.txt" |
    grep -Ev '^[[:space:]]*(#|$)'
)

(("${#packages[@]}" == 0)) || yay -S --needed -- "${packages[@]}"
