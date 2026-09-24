#!/usr/bin/env bash

# Configure greetd + Noctalia Greeter and GNOME Keyring integration.
#
# This script assumes packages/aur.txt has already been installed.
# It intentionally enables greetd for the next boot instead of starting it
# immediately, so the current graphical session is not interrupted.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if ! command -v noctalia-greeter-session >/dev/null 2>&1; then
    echo "error: noctalia-greeter is not installed. Run: bash install/aur.sh" >&2
    exit 1
fi

if ! systemctl list-unit-files greetd.service >/dev/null 2>&1; then
    echo "error: greetd.service was not found." >&2
    exit 1
fi

# Keep one copy of greetd's previous configuration for manual recovery.
if [[ -f /etc/greetd/config.toml && ! -f /etc/greetd/config.toml.pre-arch-workstation ]]; then
    sudo cp /etc/greetd/config.toml /etc/greetd/config.toml.pre-arch-workstation
fi

# Point greetd at Noctalia's supported session wrapper.
sudo install -Dm644     "$ROOT/system/greetd/config.toml"     /etc/greetd/config.toml

# Upstream ships this idempotent helper to prepare /var/lib/noctalia-greeter,
# patch greetd PAM for XDG_RUNTIME_DIR, and initialize appearance-sync state.
SETUP="/usr/share/noctalia-greeter/setup_greeter_system.sh"

if [[ -x "$SETUP" ]]; then
    sudo "$SETUP"
else
    echo "warning: $SETUP was not installed by the package." >&2
    echo "         Reinstall/update noctalia-greeter if the greeter cannot start." >&2
fi

PAM_FILE="/etc/pam.d/greetd"

if [[ ! -f "$PAM_FILE" ]]; then
    echo "error: $PAM_FILE does not exist." >&2
    exit 1
fi

# GNOME Keyring uses the login password supplied to PAM to unlock the user's
# login keyring automatically. These lines are added only when absent.
if ! grep -Eq '^[[:space:]]*auth[[:space:]]+optional[[:space:]]+pam_gnome_keyring\.so([[:space:]]|$)' "$PAM_FILE"; then
    sudo sed -i         '/^[[:space:]]*auth[[:space:]].*system-local-login/a auth       optional     pam_gnome_keyring.so'         "$PAM_FILE"
fi

if ! grep -Eq '^[[:space:]]*session[[:space:]]+optional[[:space:]]+pam_gnome_keyring\.so[[:space:]]+auto_start([[:space:]]|$)' "$PAM_FILE"; then
    sudo sed -i         '/^[[:space:]]*session[[:space:]].*system-local-login/a session    optional     pam_gnome_keyring.so auto_start'         "$PAM_FILE"
fi

# Enabling does not replace the current login screen mid-session. greetd will
# become the display manager after the next reboot.
sudo systemctl enable greetd.service

echo
echo "Noctalia Greeter configured."
echo "Review before rebooting:"
echo "  cat /etc/greetd/config.toml"
echo "  cat /etc/pam.d/greetd"
echo "  systemctl is-enabled greetd.service"
