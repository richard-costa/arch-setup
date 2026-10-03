#!/usr/bin/env bash

# Hydrate Git LFS media, then copy repository wallpaper collections into the
# normal user media folders. Safe to run repeatedly.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# A fresh clone may contain only LFS pointer files because git-lfs is installed
# later by packages/base.txt. Hydrate the real media before copying it out.
if command -v git-lfs >/dev/null 2>&1; then
  git -C "$ROOT" lfs install --local
  git -C "$ROOT" lfs pull
else
  echo "warning: git-lfs is not installed; wallpaper media may still be LFS pointers." >&2
fi

mkdir -p "$HOME/Pictures/Wallpapers" "$HOME/Videos"

if [[ -d "$ROOT/wallpapers" ]]; then
  rsync -a "$ROOT/wallpapers/" "$HOME/Pictures/Wallpapers/"
else
  echo "warning: $ROOT/wallpapers not found; skipping static wallpapers." >&2
fi

if [[ -d "$ROOT/video-wallpapers" ]]; then
  rsync -a "$ROOT/video-wallpapers/" "$HOME/Videos/"
else
  echo "warning: $ROOT/video-wallpapers not found; skipping video wallpapers." >&2
fi

echo "Wallpaper media copied to:"
echo "  $HOME/Pictures/Wallpapers"
echo "  $HOME/Videos"
