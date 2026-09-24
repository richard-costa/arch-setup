# arch-workstation

Personal setup for **vanilla Arch + linux-zen + Niri + Noctalia**.

## 1. Install Arch

Using `archinstall`:

- Minimal profile
- `linux-zen`
- NetworkManager
- PipeWire
- Btrfs with default subvolumes
- multilib enabled
- no desktop profile
- no disk encryption

More detail: [docs/archinstall.md](docs/archinstall.md)

## 2. Bootstrap the workstation

```bash
git clone https://github.com/richard-costa/arch-workstation.git
cd arch-workstation
bash install.sh
```

This installs the core packages, Niri/Noctalia desktop stack, Noctalia Greeter,
ZRAM, services, dotfiles and this laptop's monitor config.

Optional tools:

```bash
bash install/extras.sh
```

## 3. Verify Noctalia Greeter

```bash
cat /etc/greetd/config.toml
```

It should launch:

```toml
[default_session]
command = "/usr/bin/noctalia-greeter-session"
user = "greeter"
```

If needed, edit that file, then:

```bash
sudo systemctl enable greetd.service
reboot
```

See [docs/greeter.md](docs/greeter.md).

## 4. Personal setup

After logging in:

- configure Noctalia from its GUI
- enable its Niri / Kitty / GTK / VS Code / Yazi templates
- point wallpapers to `~/Pictures/Wallpapers`
- use Btrfs Assistant if snapshots are wanted
- install/configure the remembered VS Code extensions

Notes:

- [Noctalia personalization](docs/noctalia-personalization.md)
- [Noctalia theming](docs/noctalia-theming.md)
- [VS Code](docs/vscode.md)
- [Btrfs snapshots](docs/snapper.md)

## Repository layout

```text
packages/   package lists
install/    small internal setup scripts
dotfiles/   portable user config
hosts/      machine-specific config
system/     files installed under /etc
docs/       short setup notes
scripts/    migration/debugging helpers
```

Generated Noctalia colors, secrets, keyrings and machine runtime state are not
stored in Git.
