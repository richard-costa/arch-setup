#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

install_manifest() {
  local manifest="$1"
  local -a packages=()

  mapfile -t packages < <(
    sed -E 's/[[:space:]]+#.*$//' "$manifest" |
      grep -Ev '^[[:space:]]*(#|$)'
  )

  if (("${#packages[@]}" == 0)); then
    return
  fi

  sudo pacman -S --needed -- "${packages[@]}"
}
