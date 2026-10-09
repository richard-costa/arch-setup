# arch-setup

Personal executable setup for **vanilla Arch + linux-zen + Niri + Noctalia**.

This repository is the **implementation source of truth** for the workstation. Explanations, troubleshooting, and things worth remembering live in [dev-kb](https://github.com/richard-costa/dev-kb).

## Before installing

This laptop requires:

```text
nvme_core.default_ps_max_latency_us=5500
```

Full Arch installation procedure, Wi-Fi steps, Archinstall choices, and NVMe persistence instructions:

- [dev-kb: Arch installation](https://github.com/richard-costa/dev-kb/blob/main/linux/arch-install.md)

## Bootstrap

Minimal Arch may not include Git:

```bash
sudo pacman -Syu git
git clone https://github.com/richard-costa/arch-setup.git
cd arch-setup
bash install.sh
```

The bootstrap installs the system and desktop packages, bootstraps `yay`, installs and configures Noctalia Greeter, configures services and default application associations, copies wallpaper collections, deploys dotfiles, and seeds first-run application preferences.

Optional utilities, diagnostics, Btrfs Assistant and Snapper:

```bash
bash install/extras.sh
```

Tailscale can then be authenticated when wanted:

```bash
sudo tailscale up
```

## Wallpaper media

The local media folders are the freshest working copy:

```text
~/Pictures/Wallpapers/
~/Videos/
```

Sync additions and updates into this repository with:

```bash
./scripts/sync-media.sh
```

The repository keeps the canonical collections in `wallpapers/` and
`video-wallpapers/`. The sync script intentionally does not delete repository
files.

For Wallhaven images named `wallhaven-<id>.<ext>`, the original URL is derived
automatically as `https://wallhaven.cc/w/<id>`.

For media from other sources, keep the original URL in `media-sources.toml`.
The personal website reads this file when preparing its optimized homepage
copies.

## Manual follow-up

Some setup remains intentionally manual:

- run `qt6ct` and select **noctalia (KColorScheme)**
- install browser extensions such as Pywalfox / PWAsForFirefox
- install/configure the remembered VS Code extensions
- create/manage snapshots with Btrfs Assistant when wanted
- enter secrets manually

Documentation:

- [Noctalia](https://github.com/richard-costa/dev-kb/blob/main/desktop/noctalia.md)
- [Linux application notes](https://github.com/richard-costa/dev-kb/blob/main/linux/apps.md)
- [VS Code](https://github.com/richard-costa/dev-kb/blob/main/vscode.md)
- [Btrfs and Snapper](https://github.com/richard-costa/dev-kb/blob/main/linux/btrfs-snapper.md)
- [Git LFS](https://github.com/richard-costa/dev-kb/blob/main/git/lfs.md)
- [Linux diagnostics](https://github.com/richard-costa/dev-kb/blob/main/linux/diagnostics.md)

## Repository layout

```text
packages/             package lists
defaults/             first-install application preference seeds
install/              bootstrap scripts
dotfiles/             tracked user configuration
system/               files installed under /etc
scripts/              migration/debugging helpers
wallpapers/           static wallpaper collection
video-wallpapers/     animated wallpaper collection
media-sources.toml    original URLs for non-Wallhaven media
```

Generated theme files, secrets, keyrings and runtime state are not stored in Git.

## Documentation boundary

Keep executable configuration here. Keep explanations, procedures, troubleshooting, and long-term notes in `dev-kb`.

A small reminder may remain here when it is necessary to operate the setup safely, but the detailed procedure should link to `dev-kb`.

## Symlink

Add:

```text
~/arch-setup ~/Documents/projects/arch-setup
```

or another path where Git repositories are normally kept.
