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

sudo install -Dm644 \
  "$ROOT/system/NetworkManager/conf.d/10-dns-systemd-resolved.conf" \
  /etc/NetworkManager/conf.d/10-dns-systemd-resolved.conf

# Use systemd-resolved's local DNS stub. NetworkManager supplies per-network
# DNS servers to resolved through the configuration installed above.
sudo ln -sfn ../run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

echo "Installed ZRAM and systemd-resolved configuration."
echo "Reboot before verifying with: swapon --show"
