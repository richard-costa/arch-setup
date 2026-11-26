#!/usr/bin/env bash

# Install AUR packages listed in packages/aur.txt.
#
# On a fresh Arch install this script bootstraps yay from the AUR first.
set -euo pipefail

source "$(dirname "$0")/_lib.sh"

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

mapfile -t packages < <(read_manifest "$ROOT/packages/aur.txt")

(("${#packages[@]}" == 0)) || yay -S --needed -- "${packages[@]}"
