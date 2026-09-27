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
  shift

  local -a packages=()
  local -a preferred_packages=("$@")
  local package

  # Package manifests are plain text. Ignore blank lines and comments so the
  # files remain readable and can be grouped into documented sections.
  mapfile -t packages < <(
    sed -E 's/[[:space:]]+#.*$//' "$manifest" |
      grep -Ev '^[[:space:]]*(#|$)'
  )

  # Some Arch dependencies are virtual packages with multiple providers.
  # Callers may name the provider we prefer. If that package exists in the
  # enabled repositories, add it to the same pacman transaction so pacman can
  # resolve the virtual dependency without a numbered prompt.
  #
  # If a preferred package disappears or is renamed, deliberately do not fail:
  # omit it and let pacman show its normal interactive provider choice instead.
  for package in "${preferred_packages[@]}"; do
    if pacman -Si -- "$package" >/dev/null 2>&1; then
      packages+=("$package")
    else
      echo "Preferred provider '$package' was not found; pacman may ask you to choose manually."
    fi
  done

  # Nothing to install is a valid state.
  if (("${#packages[@]}" == 0)); then
    return
  fi

  # --needed avoids reinstalling packages that are already current.
  # "--" prevents a package name from accidentally being treated as an option.
  sudo pacman -S --needed -- "${packages[@]}"
}
