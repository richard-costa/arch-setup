#!/usr/bin/env bash

# Deploy hardware-specific configuration after the portable dotfiles.
#
# Usage:
#   ./install/host.sh acer-laptop
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
HOST="${1:-}"

if [[ -z "$HOST" ]]; then
    echo "usage: $0 <host>" >&2
    exit 1
fi

HOST_DIR="$ROOT/hosts/$HOST"

if [[ ! -d "$HOST_DIR" ]]; then
    echo "error: unknown host: $HOST" >&2
    exit 1
fi

case "$HOST" in
    acer-laptop)
        # Niri's main config includes cfg/display.kdl. The monitor connectors
        # and positions are specific to this laptop/setup.
        mkdir -p "$HOME/.config/niri/cfg"
        ln -sfn             "$HOST_DIR/niri/display.kdl"             "$HOME/.config/niri/cfg/display.kdl"

        echo "Acer laptop configuration deployed."
        ;;
    *)
        echo "error: no deployment rules defined for host: $HOST" >&2
        exit 1
        ;;
esac
