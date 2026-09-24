#!/usr/bin/env bash

# Copy repository-managed system configuration into /etc.
# Keep these files separate from package installation so changes are obvious.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# Enable compressed RAM swap. The source file stays version-controlled under
# system/ and is installed with normal root-owned configuration permissions.
sudo install -Dm644 \
  "$ROOT/system/zram-generator.conf" \
  /etc/systemd/zram-generator.conf

echo "Installed zram-generator configuration."
echo "Reboot before verifying with: swapon --show"
