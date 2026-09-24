#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/_lib.sh"
install_manifest "$ROOT/packages/extras.txt"
