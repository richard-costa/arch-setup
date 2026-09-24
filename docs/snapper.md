# Snapper

Snapper is optional but recommended because this workstation uses Btrfs.

Run:

```bash
bash install/snapper.sh
```

The script only creates a root configuration when:

- `/` is Btrfs
- no Snapper `root` config already exists
- `/.snapshots` is not already a mount point/subvolume/path

If the layout is ambiguous, it stops instead of deleting or remounting anything.

## What is snapshotted

The Archinstall layout uses separate Btrfs subvolumes such as `@home`.
Btrfs snapshots are not recursive, so a snapshot of `/` does **not** include
separate subvolumes such as `/home`.

That is desirable here: system rollback should not silently roll personal files
back in time.

## Automation

`snapper-timeline.timer` creates timeline snapshots and
`snapper-cleanup.timer` removes snapshots according to Snapper's retention
configuration.

The optional `snap-pac` package also creates snapshots around pacman
transactions.

## Restore

This repository does not automate rollback. Restoring the root subvolume is a
recovery operation that should be done deliberately, often from an Arch live
environment.

Useful inspection commands:

```bash
sudo snapper -c root list
sudo btrfs subvolume list /
systemctl list-timers 'snapper-*'
```
