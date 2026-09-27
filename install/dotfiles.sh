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

# Nautilus and other GTK apps read these appearance settings from GNOME
# interface preferences. The bootstrap normally runs from a TTY, so create a
# temporary D-Bus session when there is no existing graphical session bus.
set_gsettings() {
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
    gsettings set org.gnome.desktop.interface cursor-theme 'capitaine-cursors'
    gsettings set org.gnome.desktop.interface icon-theme 'breeze-dark'
}

if [[ -n "${DBUS_SESSION_BUS_ADDRESS:-}" ]]; then
    set_gsettings
else
    dbus-run-session -- bash -c "$(declare -f set_gsettings); set_gsettings"
fi

# Noctalia generates these after login/theme changes. Empty placeholders keep
# Niri and Kitty happy before the first generated palette exists.
mkdir -p "$HOME/.config/niri" "$HOME/.config/kitty/themes"
touch "$HOME/.config/niri/noctalia.kdl"
touch "$HOME/.config/kitty/themes/noctalia.conf"

echo "Portable dotfiles deployed."
