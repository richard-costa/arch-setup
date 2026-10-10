#!/usr/bin/env bash

# Install the curated VS Code extensions for this workstation.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
manifest="$ROOT/packages/vscode-extensions.txt"

if ! command -v code >/dev/null 2>&1; then
  echo "error: VS Code CLI 'code' is not installed." >&2
  exit 1
fi

mapfile -t extensions < <(
  sed -E 's/[[:space:]]+#.*$//' "$manifest" |
    grep -Ev '^[[:space:]]*(#|$)'
)

for extension in "${extensions[@]}"; do
  code --install-extension "$extension"
done
