# arch-workstation

Personal Arch Linux workstation bootstrap and configuration.

## Stack

Arch + linux-zen + Niri + Noctalia + Fish + Kitty + PipeWire + NetworkManager + Btrfs/ZRAM.

## How the repo fits together

```text
packages/   what software should exist
install/    installs packages and enables/configures them
system/     version-controlled files that get copied into /etc
dotfiles/   portable user configuration
hosts/      hardware/machine-specific configuration
scripts/    inspection and maintenance helpers
docs/       short explanations and migration notes
```

Package manifests and scripts are intentionally commented so dependencies and behavior remain understandable later.

## Fresh install

Start with [docs/archinstall.md](docs/archinstall.md), then:

```bash
bash install/base.sh
bash install/desktop.sh
bash install/extras.sh      # optional
bash install/aur.sh
bash install/greeter.sh
bash install/system.sh
bash install/services.sh
bash install/dotfiles.sh
bash install/host.sh acer-laptop
bash install/snapper.sh      # optional
```

## Config migration

System overview:

```bash
bash scripts/system-survey.sh
```

Niri/Fish/Kitty/audio config review:

```bash
bash scripts/config-survey.sh
```

Do not commit survey output. Review it before sharing.

See:

- [Configuration layout](docs/config-layout.md)
- [Noctalia theming](docs/noctalia-theming.md)
- [Noctalia personalization](docs/noctalia-personalization.md)
- [Greeter and keyring](docs/greeter.md)
- [Snapper](docs/snapper.md)
- [Current CachyOS baseline](docs/current-cachyos-baseline.md)
