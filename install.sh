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
# install/aur.sh explains how to install yay if it is missing.
bash "$ROOT/install/aur.sh"

# Install small /etc configuration owned by this repo (currently ZRAM).
bash "$ROOT/install/system.sh"

# Enable networking, Bluetooth, TRIM, firewall/timers when installed, and NTP.
bash "$ROOT/install/services.sh"

# Link portable user configuration, then apply this laptop's monitor layout.
bash "$ROOT/install/dotfiles.sh"
bash "$ROOT/install/host.sh" acer-laptop

echo
echo "Core workstation setup finished."
echo "Next: verify /etc/greetd/config.toml as shown in README.md, then reboot."
