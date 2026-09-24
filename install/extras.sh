#!/usr/bin/env bash

# Install useful but non-essential tools from packages/extras.txt.
# This layer can be skipped on a minimal installation and added later.
set -euo pipefail

source "$(dirname "$0")/_lib.sh"

install_manifest "$ROOT/packages/extras.txt"
