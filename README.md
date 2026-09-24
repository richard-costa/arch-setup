# arch-workstation

Personal setup for **vanilla Arch + linux-zen + Niri + Noctalia**.

## 1. Install Arch

In `archinstall` choose:

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
git clone https://github.com/richard-costa/arch-workstation.git
cd arch-workstation
bash install.sh
```

The bootstrap installs the core system/desktop packages, builds `yay` if needed,
installs Noctalia Greeter, configures ZRAM/services, and links the dotfiles.

Optional utilities, diagnostics, Btrfs Assistant and Snapper:

```bash
bash install/extras.sh
```

## 3. Verify Noctalia Greeter

Check:

```bash
cat /etc/greetd/config.toml
```

It should contain:

```toml
[default_session]
command = "/usr/bin/noctalia-greeter-session"
user = "greeter"
```

If needed, edit the file, then enable greetd:

```bash
sudo systemctl enable greetd.service
reboot
```

## 4. Personal setup

After logging in:

- configure Noctalia from its GUI
- point wallpapers to `~/Pictures/Wallpapers`
- enable the wanted Noctalia templates
- run `qt6ct` once and select the Noctalia KColorScheme for Qt apps
- use **Btrfs Assistant** if snapshots are wanted
- install/configure the remembered VS Code extensions

Notes:

- [Noctalia personalization](docs/noctalia-personalization.md)
- [VS Code](docs/vscode.md)
- [Btrfs snapshots](docs/snapper.md)

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
