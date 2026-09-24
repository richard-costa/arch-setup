#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

sudo install -Dm644   "$ROOT/system/zram-generator.conf"   /etc/systemd/zram-generator.conf

echo "Installed zram-generator configuration."
echo "Reboot before verifying with: swapon --show"
