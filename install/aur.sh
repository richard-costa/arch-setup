#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if ! command -v yay >/dev/null 2>&1; then
  cat >&2 <<'EOF'
error: yay is not installed.

Install yay first, then rerun:
  ./install/aur.sh
EOF
  exit 1
fi

mapfile -t packages < <(
  sed -E 's/[[:space:]]+#.*$//' "$ROOT/packages/aur.txt" |
    grep -Ev '^[[:space:]]*(#|$)'
)

(("${#packages[@]}" == 0)) || yay -S --needed -- "${packages[@]}"
