# arch-setup

Personal setup for **vanilla Arch + linux-zen + Niri + Noctalia**.

## 1. Install Arch

### Required NVMe boot parameter

This laptop needs the following kernel parameter on Linux:

```text
nvme_core.default_ps_max_latency_us=5500
```

Before the Arch installer starts, select the Arch install entry in the boot menu,
press `e`, append the parameter to the kernel command line, and press Enter.

After Arch is installed, make the same parameter persistent in the installed
bootloader before relying on normal boots. See
[troubleshooting](docs/troubleshooting.md#nvme-boot-parameter).

Then in `archinstall` choose:

- Minimal profile
- `linux-zen`
- NetworkManager
- PipeWire
- Btrfs with default subvolumes
- multilib enabled
- no desktop profile
- no disk encryption

## 2. Bootstrap

Minimal Arch does not add Git by itself, so install it first:

```bash
sudo pacman -Syu git
git clone https://github.com/richard-costa/arch-setup.git
cd arch-setup
bash install.sh
```

The bootstrap installs the core system/desktop packages, builds `yay` if needed,
installs and configures Noctalia Greeter, configures ZRAM/DNS/services, and
links the dotfiles.

Optional utilities, diagnostics, Btrfs Assistant and Snapper:

```bash
bash install/extras.sh
```

This optional set includes Tailscale. Its service is enabled automatically;
authenticate this machine with your Tailscale account after installation:

```bash
sudo tailscale up
```

## 3. Reboot Into Noctalia Greeter

The bootstrap configures `/etc/greetd/config.toml`, creates the dedicated
`greeter` system account when needed, and enables `greetd.service`.

It also configures NetworkManager to use `systemd-resolved` and links
`/etc/resolv.conf` to its local DNS stub. This preserves DNS handling for
ordinary networks and Tailscale's private DNS routes.

## 4. Personal setup

After logging in:

- configure Noctalia from its GUI
- copy the repo wallpapers into `~/Pictures/Wallpapers` and video wallpapers into `~/Videos`
- enable the wanted Noctalia templates
- run `qt6ct` once and select the Noctalia KColorScheme for Qt apps
- use **Btrfs Assistant** if snapshots are wanted
- install/configure the remembered VS Code extensions

Notes:

- [Noctalia personalization](docs/noctalia-personalization.md)
- [Application setup](docs/apps.md)
- [VS Code](docs/vscode.md)
- [Btrfs snapshots](docs/snapper.md)
- [Troubleshooting](docs/troubleshooting.md)

## Repository layout

```text
packages/   package lists
install/    small scripts used by install.sh
dotfiles/   Niri, Fish and Kitty config
system/     files installed under /etc
docs/       short personal setup notes
scripts/    temporary migration/debugging helpers
```

Generated theme files, secrets, keyrings and runtime state are not stored in Git.
