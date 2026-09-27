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

stow --restow --no-folding --target="$HOME" niri fish kitty noctalia yazi pipewire

# Nautilus and other GTK apps read these appearance settings from GNOME
# interface preferences. The bootstrap normally runs from a TTY, so create a
# temporary D-Bus session when there is no existing graphical session bus.
set_gsettings() {
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
    gsettings set org.gnome.desktop.interface cursor-theme 'capitaine-cursors'
    gsettings set org.gnome.desktop.interface icon-theme 'breeze-dark'
    gsettings set org.gnome.desktop.interface font-name 'Noto Sans 11'
    gsettings set org.gnome.desktop.interface document-font-name 'Noto Sans 11'
    gsettings set org.gnome.desktop.interface monospace-font-name 'MesloLGS Nerd Font Mono 11'
}

if [[ -n "${DBUS_SESSION_BUS_ADDRESS:-}" ]]; then
    set_gsettings
else
    dbus-run-session -- bash -c "$(declare -f set_gsettings); set_gsettings"
fi

# Seed qt6ct fonts only when there is no existing qt6ct configuration. The
# Noctalia KColorScheme itself is selected later in qt6ct and should remain
# user-editable after first boot.
QT6CT_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/qt6ct"
QT6CT_CONFIG="$QT6CT_DIR/qt6ct.conf"
if [[ ! -e "$QT6CT_CONFIG" ]]; then
    mkdir -p "$QT6CT_DIR"
    cp "$ROOT/defaults/qt6ct.conf" "$QT6CT_CONFIG"
    echo "Seeded qt6ct font preferences."
else
    echo "Existing qt6ct config found; leaving it unchanged."
fi

# Fastfetch needs a real config.jsonc for its module list and for Noctalia's
# generated palette hook. Seed it once; Noctalia can later merge colors into it.
FASTFETCH_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/fastfetch"
FASTFETCH_CONFIG="$FASTFETCH_DIR/config.jsonc"
if [[ ! -e "$FASTFETCH_CONFIG" ]]; then
    mkdir -p "$FASTFETCH_DIR"
    cp "$ROOT/defaults/fastfetch-config.jsonc" "$FASTFETCH_CONFIG"
    echo "Seeded Fastfetch configuration."
else
    echo "Existing Fastfetch config found; leaving it unchanged."
fi

# Seed Noctalia's GUI-managed preferences only on the first install. The copied
# settings.toml is deliberately not a symlink: after this point Noctalia owns it
# and can rewrite it normally when settings are changed in the GUI.
NOCTALIA_STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/noctalia"
NOCTALIA_SETTINGS="$NOCTALIA_STATE_DIR/settings.toml"
NOCTALIA_SEED="$ROOT/defaults/noctalia-settings.toml"

if [[ ! -e "$NOCTALIA_SETTINGS" ]]; then
    mkdir -p "$NOCTALIA_STATE_DIR"
    escaped_home="$(printf '%s' "$HOME" | sed 's/[\/&]/\\&/g')"
    tmp_settings="$(mktemp "$NOCTALIA_STATE_DIR/settings.toml.XXXXXX")"
    sed "s/@HOME@/$escaped_home/g" "$NOCTALIA_SEED" > "$tmp_settings"
    chmod 600 "$tmp_settings"
    mv "$tmp_settings" "$NOCTALIA_SETTINGS"
    echo "Seeded initial Noctalia settings."
else
    echo "Existing Noctalia settings found; leaving them unchanged."
fi

# Noctalia generates these after login/theme changes. Empty placeholders keep
# Niri and Kitty happy before the first generated palette exists.
mkdir -p "$HOME/.config/niri" "$HOME/.config/kitty/themes"
touch "$HOME/.config/niri/noctalia.kdl"
touch "$HOME/.config/kitty/themes/noctalia.conf"

echo "Portable dotfiles deployed."
