#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/_lib.sh"

sudo pacman -Syu
install_manifest "$ROOT/packages/base.txt"
