#!/usr/bin/env bash

# Sync local wallpaper collections into this repository.
# The repository remains the source of truth; this only adds/updates files
# and intentionally does not delete files from the repository.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

rsync -r "$HOME/Pictures/Wallpapers/" "$ROOT/wallpapers/"
rsync -r "$HOME/Videos/" "$ROOT/video-wallpapers/"

echo "Synced local media into:"
echo "  $ROOT/wallpapers"
echo "  $ROOT/video-wallpapers"
