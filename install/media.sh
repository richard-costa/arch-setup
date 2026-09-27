#!/usr/bin/env bash

# Copy repository wallpaper collections into the normal user media folders.
# Safe to run repeatedly; rsync only updates changed/new files.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

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
