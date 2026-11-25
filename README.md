# arch-setup

Executable workstation setup for **vanilla Arch + linux-zen + Niri + Noctalia**. Configuration lives here; explanations and troubleshooting belong in [knowledge-base](https://github.com/richard-costa/knowledge-base).

## Before installing

This laptop requires `nvme_core.default_ps_max_latency_us=5500`. See [Arch installation](https://github.com/richard-costa/knowledge-base/blob/main/linux/arch-install.md) for Wi-Fi, Archinstall and persistent NVMe configuration.

## Bootstrap

```bash
sudo pacman -Syu git
git clone https://github.com/richard-costa/arch-setup.git
cd arch-setup
bash install.sh
```

Installs packages, yay, Noctalia Greeter, services, default app associations, wallpapers, dotfiles and first-run preferences.

- Swap: default ZRAM plus an 8 GiB Btrfs swapfile at `/swap/swapfile`, priority 10. Its subvolume excludes it from root snapshots. `install/swap.sh` refuses non-Btrfs roots or non-`single` data profiles.
- Lid: `system/systemd/logind.conf.d/90-clamshell.conf` keeps the laptop awake on external power or when docked; battery behavior is unchanged.

Optional utilities, diagnostics, Btrfs Assistant and Snapper:

```bash
bash install/extras.sh
sudo tailscale up  # optional authentication
```

## Wallpaper media

Sync `~/Pictures/Wallpapers/` and `~/Videos/` to `wallpapers/` and `video-wallpapers/`:

```bash
./scripts/sync-media.sh
```

Sync never deletes repository files. Wallhaven filenames `wallhaven-<id>.<ext>` imply `https://wallhaven.cc/w/<id>`; record other source URLs in `media-sources.toml` for website media preparation.

## Manual follow-up

- Select **noctalia (KColorScheme)** in `qt6ct`.
- Install browser extensions (Pywalfox/PWAsForFirefox) and remembered VS Code extensions.
- Manage snapshots with Btrfs Assistant; enter secrets manually.

Reference: [Noctalia](https://github.com/richard-costa/knowledge-base/blob/main/desktop/noctalia.md), [apps](https://github.com/richard-costa/knowledge-base/blob/main/linux/apps.md), [VS Code](https://github.com/richard-costa/knowledge-base/blob/main/editor/vscode.md), [Btrfs/Snapper](https://github.com/richard-costa/knowledge-base/blob/main/linux/btrfs-snapper.md), [Git LFS](https://github.com/richard-costa/knowledge-base/blob/main/git/lfs.md), [diagnostics](https://github.com/richard-costa/knowledge-base/blob/main/linux/diagnostics.md).

## Repository layout

| Path | Purpose |
|---|---|
| `packages/` | Package lists |
| `defaults/` | First-run preference seeds |
| `install/` | Bootstrap scripts |
| `dotfiles/` | User configuration |
| `system/` | Files installed under /etc |
| `scripts/` | Migration/debugging helpers |
| `wallpapers/`, `video-wallpapers/` | Media collections |
| `media-sources.toml` | Non-Wallhaven source URLs |

Do not commit generated themes, secrets, keyrings or runtime state.

## Symlink

Link `~/arch-setup` to `~/Documents/projects/arch-setup` (or the actual checkout).
