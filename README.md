# arch-workstation

Personal Arch Linux workstation bootstrap and configuration.

## Stack

- Arch Linux
- linux-zen
- Niri
- Noctalia
- Noctalia Greeter / greetd
- Fish
- Kitty
- PipeWire / WirePlumber
- NetworkManager
- Btrfs + ZRAM
- AMDGPU / Mesa / RADV

## Repository layout

```text
arch-workstation/
├── install/      # bootstrap scripts
├── packages/     # pacman/AUR package manifests
├── system/       # files installed under /etc
├── scripts/      # inspection and maintenance helpers
├── docs/         # installation and migration notes
├── dotfiles/     # personal application configuration (later)
└── hosts/        # machine-specific configuration (later)
```

## Fresh install

Start with [docs/archinstall.md](docs/archinstall.md).

Typical post-install flow:

```bash
./install/base.sh
./install/desktop.sh
./install/extras.sh      # optional
./install/aur.sh
./install/system.sh
./install/services.sh
```

## Package philosophy

- `base.txt`: foundational OS/plumbing
- `desktop.txt`: Niri/Noctalia desktop functionality expected every day
- `extras.txt`: useful but removable conveniences
- `aur.txt`: AUR-only packages

Personal applications can be added separately without mixing them into the core workstation plumbing.

## Migration survey

```bash
bash scripts/system-survey.sh
```

The survey is intended for migration/debugging and should not be committed as machine state.

## Current status

This repository is being built from an existing CachyOS + Niri + Noctalia installation. See [docs/current-cachyos-baseline.md](docs/current-cachyos-baseline.md).
