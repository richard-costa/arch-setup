#!/usr/bin/env bash

# Install packages that are not in the official Arch repositories.
# AUR packages are listed separately in packages/aur.txt.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# We use yay as the AUR helper, but do not bootstrap it automatically because
# AUR helpers themselves are user-built packages that should be reviewed.
if ! command -v yay >/dev/null 2>&1; then
  cat >&2 <<'EOF'
error: yay is not installed.

Install yay first, then rerun:
  ./install/aur.sh
EOF
  exit 1
fi

# Read the manifest while ignoring comments and empty lines.
mapfile -t packages < <(
  sed -E 's/[[:space:]]+#.*$//' "$ROOT/packages/aur.txt" |
    grep -Ev '^[[:space:]]*(#|$)'
)

# --needed avoids rebuilding/reinstalling packages already present.
(("${#packages[@]}" == 0)) || yay -S --needed -- "${packages[@]}"
