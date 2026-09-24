#!/usr/bin/env bash

# Shared helpers used by the pacman install scripts.
#
# "set -euo pipefail" makes scripts stop on errors, undefined variables,
# or failed commands inside pipelines instead of continuing silently.
set -euo pipefail

# Repository root, regardless of which directory the script is launched from.
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

install_manifest() {
  local manifest="$1"
  local -a packages=()

  # Package manifests are plain text. Ignore blank lines and comments so the
  # files remain readable and can be grouped into documented sections.
  mapfile -t packages < <(
    sed -E 's/[[:space:]]+#.*$//' "$manifest" |
      grep -Ev '^[[:space:]]*(#|$)'
  )

  # Nothing to install is a valid state.
  if (("${#packages[@]}" == 0)); then
    return
  fi

  # --needed avoids reinstalling packages that are already current.
  # "--" prevents a package name from accidentally being treated as an option.
  sudo pacman -S --needed -- "${packages[@]}"
}
