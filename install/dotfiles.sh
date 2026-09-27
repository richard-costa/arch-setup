#!/usr/bin/env bash

# Deploy portable user configuration with GNU Stow.
#
# --no-folding links individual tracked files instead of replacing whole config
# directories with symlinks. This leaves room for Noctalia-generated files.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if ! command -v stow >/dev/null 2>&1; then
    echo "error: GNU Stow is not installed. Run: bash install/base.sh" >&2
    exit 1
fi

cd "$ROOT/dotfiles"

stow --restow --no-folding --target="$HOME" niri fish kitty noctalia yazi

# Nautilus and other GTK apps read the icon theme from GNOME interface
# settings. The bootstrap normally runs from a TTY, so create a temporary
# D-Bus session when there is no existing graphical session bus.
if [[ -n "${DBUS_SESSION_BUS_ADDRESS:-}" ]]; then
    gsettings set org.gnome.desktop.interface icon-theme 'breeze-dark'
else
    dbus-run-session -- gsettings set org.gnome.desktop.interface icon-theme 'breeze-dark'
fi

# Noctalia generates these after login/theme changes. Empty placeholders keep
# Niri and Kitty happy before the first generated palette exists.
mkdir -p "$HOME/.config/niri" "$HOME/.config/kitty/themes"
touch "$HOME/.config/niri/noctalia.kdl"
touch "$HOME/.config/kitty/themes/noctalia.conf"

echo "Portable dotfiles deployed."
