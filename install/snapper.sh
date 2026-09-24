#!/usr/bin/env bash

# Configure Snapper for root (/) snapshots on Btrfs.
#
# This script is deliberately conservative: it refuses to modify an existing
# /.snapshots layout because guessing around Btrfs subvolumes can make rollback
# harder rather than safer.
set -euo pipefail

if ! command -v snapper >/dev/null 2>&1; then
    echo "error: snapper is not installed." >&2
    echo "Install packages/extras.txt first: bash install/extras.sh" >&2
    exit 1
fi

ROOT_FS="$(findmnt -n -o FSTYPE /)"

if [[ "$ROOT_FS" != "btrfs" ]]; then
    echo "error: / is $ROOT_FS, not Btrfs. Snapper setup stopped." >&2
    exit 1
fi

# If root is already configured, do not recreate it. Just ensure the normal
# systemd timers are enabled.
if sudo snapper list-configs 2>/dev/null | awk '{print $1}' | grep -qx root; then
    echo "Snapper root config already exists; leaving it unchanged."
    sudo systemctl enable --now snapper-timeline.timer snapper-cleanup.timer
    exit 0
fi

# A pre-existing mount/subvolume here needs layout-specific handling. Refuse
# instead of deleting or unmounting anything automatically.
if mountpoint -q /.snapshots; then
    echo "error: /.snapshots is already a mount point." >&2
    echo "See docs/snapper.md and configure this layout manually." >&2
    exit 1
fi

if sudo btrfs subvolume show /.snapshots >/dev/null 2>&1; then
    echo "error: /.snapshots already exists as a Btrfs subvolume." >&2
    echo "See docs/snapper.md and configure this layout manually." >&2
    exit 1
fi

if [[ -e /.snapshots ]]; then
    echo "error: /.snapshots already exists as a regular path." >&2
    echo "Move/inspect it manually before running this script." >&2
    exit 1
fi

# Creates /etc/snapper/configs/root and a /.snapshots subvolume.
sudo snapper -c root create-config /

# Timeline snapshots and automatic cleanup use systemd; no cron daemon needed.
sudo systemctl enable --now snapper-timeline.timer snapper-cleanup.timer

echo
echo "Snapper root snapshots configured."
echo "Verify with:"
echo "  sudo snapper -c root list"
echo "  systemctl list-timers 'snapper-*'"
