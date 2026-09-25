# Btrfs snapshots

Use **Btrfs Assistant** rather than a custom setup script.

Install the optional extras:

```bash
bash install/extras.sh
```

Then open **Btrfs Assistant** and create/manage a Snapper configuration for `/`.

Relevant packages:

- `btrfs-assistant` — GUI
- `snapper` — snapshot backend
- `snap-pac` — snapshots around pacman transactions

The Archinstall layout keeps `/home` in a separate Btrfs subvolume, so root
snapshots do not automatically roll personal files backward.

Useful CLI inspection:

```bash
sudo snapper list-configs
sudo snapper -c root list
sudo btrfs subvolume list /
```

Rollback is intentionally not automated by this repository.
