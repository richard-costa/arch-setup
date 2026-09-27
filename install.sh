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

# Copy the curated wallpaper collections into the normal user media folders so
# Noctalia and mpvpaper can use their seeded directories on first login.
bash "$ROOT/install/media.sh"

# Link portable user configuration and seed Noctalia's first-install GUI
# preferences before making Fish the login shell.
bash "$ROOT/install/dotfiles.sh"

# Reload PipeWire after its RNNoise configuration is linked and persist the
# generated Clean Microphone source as the default input.
bash "$ROOT/install/audio.sh"

# Fish is installed by install/desktop.sh. Make it the login shell only after
# its configuration has been deployed; the change takes effect next login.
bash "$ROOT/install/shell.sh"

echo
echo "Core workstation setup finished."
echo "Reboot or log out to start the Noctalia Greeter and Fish login shell."
