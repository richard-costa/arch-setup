#!/usr/bin/env bash

# Install the curated VS Code extensions for this workstation.
set -euo pipefail

source "$(dirname "$0")/_lib.sh"
manifest="$ROOT/packages/vscode-extensions.txt"

if ! command -v code >/dev/null 2>&1; then
  echo "error: VS Code CLI 'code' is not installed." >&2
  exit 1
fi

mapfile -t extensions < <(read_manifest "$manifest")

for extension in "${extensions[@]}"; do
  code --install-extension "$extension"
done
