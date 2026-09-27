#!/usr/bin/env bash

# Make Fish the login shell for the user who launched the bootstrap.
#
# This runs near the end of install.sh, after Fish is installed and its dotfiles
# are deployed. Changing the login shell does not replace the shell running this
# script; it takes effect on the next login.
set -euo pipefail

TARGET_USER="${SUDO_USER:-${USER:-}}"
FISH_SHELL="/usr/bin/fish"

if [[ -z "$TARGET_USER" ]]; then
  echo "error: could not determine the target user for the login shell." >&2
  exit 1
fi

if [[ ! -x "$FISH_SHELL" ]]; then
  echo "error: $FISH_SHELL is not installed. Run install/desktop.sh first." >&2
  exit 1
fi

if ! grep -Fxq "$FISH_SHELL" /etc/shells; then
  echo "error: $FISH_SHELL is not listed in /etc/shells." >&2
  exit 1
fi

CURRENT_SHELL="$(getent passwd "$TARGET_USER" | cut -d: -f7)"

if [[ "$CURRENT_SHELL" == "$FISH_SHELL" ]]; then
  echo "Fish is already the login shell for $TARGET_USER."
  exit 0
fi

sudo chsh -s "$FISH_SHELL" "$TARGET_USER"
echo "Fish set as the login shell for $TARGET_USER; it will be used after the next login."
