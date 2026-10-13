#!/usr/bin/env bash

# Provision a low-priority disk-backed swapfile as fallback behind ZRAM.
# The workstation root is Btrfs; keep swap in its own nested subvolume so root
# snapshots do not include the active swapfile. This does not add encryption;
# swap inherits the protection of the underlying storage.
set -euo pipefail

SWAP_DIR="/swap"
SWAP_FILE="$SWAP_DIR/swapfile"
SWAP_SIZE="8G"
SWAP_SIZE_BYTES=$((8 * 1024 * 1024 * 1024))
SWAP_PRIORITY="10"
FSTAB_LINE="$SWAP_FILE none swap defaults,pri=$SWAP_PRIORITY 0 0"

if [[ "$(findmnt -n -o FSTYPE /)" != "btrfs" ]]; then
  echo "Refusing to configure $SWAP_FILE: root filesystem is not Btrfs." >&2
  exit 1
fi

if ! sudo btrfs filesystem usage / | grep -q '^Data,single:'; then
  echo "Refusing to configure $SWAP_FILE: Btrfs data profile is not single." >&2
  exit 1
fi

if [[ -e "$SWAP_DIR" ]]; then
  if ! sudo btrfs subvolume show "$SWAP_DIR" >/dev/null 2>&1; then
    echo "Refusing to use $SWAP_DIR: it exists but is not a Btrfs subvolume." >&2
    exit 1
  fi
else
  sudo btrfs subvolume create "$SWAP_DIR"
fi

if [[ -e "$SWAP_FILE" ]]; then
  if [[ ! -f "$SWAP_FILE" ]]; then
    echo "Refusing to use $SWAP_FILE: it exists but is not a regular file." >&2
    exit 1
  fi

  actual_size="$(stat -c %s "$SWAP_FILE")"
  if (( actual_size != SWAP_SIZE_BYTES )); then
    echo "Refusing to replace $SWAP_FILE: expected $SWAP_SIZE_BYTES bytes, found $actual_size." >&2
    exit 1
  fi
else
  sudo btrfs filesystem mkswapfile --size "$SWAP_SIZE" "$SWAP_FILE"
fi

# Validate Btrfs swapfile constraints before activation.
sudo btrfs inspect-internal map-swapfile "$SWAP_FILE" >/dev/null

if ! swapon --show=NAME --noheadings | grep -Fxq "$SWAP_FILE"; then
  sudo swapon -p "$SWAP_PRIORITY" "$SWAP_FILE"
fi

if grep -Eq '^[[:space:]]*/swap/swapfile[[:space:]]+' /etc/fstab; then
  if ! grep -Fqx "$FSTAB_LINE" /etc/fstab; then
    echo "Refusing to edit /etc/fstab: an existing $SWAP_FILE entry differs." >&2
    exit 1
  fi
else
  printf '%s\n' "$FSTAB_LINE" | sudo tee -a /etc/fstab >/dev/null
fi

sudo systemctl daemon-reload

echo "Configured $SWAP_SIZE Btrfs fallback swap at priority $SWAP_PRIORITY."
swapon --show
