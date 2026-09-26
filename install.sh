#!/usr/bin/env bash

# Main workstation bootstrap.
#
# This is the entry point documented in the README. The smaller scripts remain
# separate so each concern is easy to understand and change later.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"

bash "$ROOT/install/base.sh"
bash "$ROOT/install/desktop.sh"

# AUR packages currently include Noctalia Greeter.
# install/aur.sh bootstraps yay automatically when needed.
bash "$ROOT/install/aur.sh"

# Install the Noctalia Greeter configuration and enable greetd.
bash "$ROOT/install/greeter.sh"

# Install small /etc configuration owned by this repo (currently ZRAM).
bash "$ROOT/install/system.sh"

# Enable networking, Bluetooth, TRIM, firewall/timers when installed, and NTP.
bash "$ROOT/install/services.sh"

# Link portable user configuration.
bash "$ROOT/install/dotfiles.sh"

echo
echo "Core workstation setup finished."
echo "Reboot to start the Noctalia Greeter."
