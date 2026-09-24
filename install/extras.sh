#!/usr/bin/env bash

# Install useful but non-essential tools from packages/extras.txt.
# This can be skipped initially and run later.
set -euo pipefail

source "$(dirname "$0")/_lib.sh"

install_manifest "$ROOT/packages/extras.txt"

# Some optional packages provide services/timers (UFW, paccache, pkgfile).
# Re-run the idempotent service setup so those are enabled when present.
bash "$ROOT/install/services.sh"
