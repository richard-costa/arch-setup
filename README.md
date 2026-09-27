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

After booting the live ISO, verify that it was applied:

```bash
cat /proc/cmdline
```

The output should contain `nvme_core.default_ps_max_latency_us=5500`.

After Arch is installed, make the same parameter persistent in the installed
bootloader before relying on normal boots. See
[troubleshooting](docs/troubleshooting.md#nvme-boot-parameter).

### Connect the live ISO to Wi-Fi

`archinstall` needs a working internet connection first. For Wi-Fi, run:

```bash
iwctl
```

Then inside `iwctl`:

```text
device list
station wlan0 scan
station wlan0 get-networks
station wlan0 connect "YOUR_WIFI_NAME"
```

Enter the Wi-Fi password when prompted, then:

```text
exit
```

Verify the connection:

```bash
ping -c 3 archlinux.org
```

If the Wi-Fi device is not named `wlan0`, use the name shown by `device list`.
Ethernet can skip the `iwctl` steps if networking already works.

### Archinstall

Start the installer:

```bash
archinstall
```

Configure the menu in this order:

1. **Archinstall language** — leave the installer language as wanted.
2. **Locales**
   - keyboard layout: `br-abnt2`
   - locale language: `en_US.UTF-8`
   - locale encoding: `UTF-8`
3. **Mirrors and repositories**
   - mirror region: **Brazil**
   - under optional repositories enable **only `multilib`**
   - leave `multilib-testing`, `core-testing`, and `extra-testing` disabled
4. **Disk configuration**
   - choose **Use a best-effort default partition layout**
   - select the internal NVMe: `/dev/nvme0n1`
   - do **not** select the Ventoy USB
   - filesystem: **Btrfs**
   - use the default Btrfs subvolumes
   - choose **Use compression**
   - no disk encryption
   - no LVM
   - do not configure snapshots here; Snapper/Btrfs Assistant can be added later
5. **Swap**
   - **Swap on ZRAM: No** — this repo installs and configures ZRAM later
6. **Bootloader**
   - **systemd-boot**
   - keep the current **Unified Kernel Image (UKI)** setting enabled
   - do not enable Limine
7. **Kernels**
   - select **only `linux-zen`**
8. **Hostname**
   - `archlinux`
9. **Authentication**
   - create one normal user
   - give the user sudo/superuser privileges
   - root password can remain unset
   - leave U2F login setup unchanged unless intentionally using a hardware security key
10. **Profile**
    - select **Minimal**
11. **Applications**
    - leave empty; the repo installs the desktop/application stack later
12. **Network configuration**
    - select **NetworkManager**
    - choose **Default backend**, not the iwd backend
13. **Pacman**
    - leave **Color** enabled
    - `multilib` is configured earlier under **Mirrors and repositories**, not here
14. **Additional packages**
    - leave empty
15. **Timezone**
    - `America/Sao_Paulo`
16. **Automatic time sync (NTP)**
    - **Yes**

### Expected final Archinstall summary

Before selecting **Install**, the summary should look like this:

```text
Hostname                    : archlinux
Kernels                     : linux-zen
Automatic Time Sync (NTP)   : Yes
Timezone                    : America/Sao_Paulo
Pacman                      : Color enabled
Mirrors and Repositories    : Mirror regions "Brazil"
                              Optional repositories "multilib"
Bootloader                  : Bootloader "Systemd-boot"
                              UKI enabled
Disk Configuration          : Default layout
                              Devices /dev/nvme0n1
Authentication              : Configured 1 user(s)
Locales                     : Keyboard layout "br-abnt2"
                              Locale language "en_US.UTF-8"
                              Locale encoding "UTF-8"
                              Console font "default8x16"
Profile                     : Minimal
Network                     : Use Network Manager (default backend)
```

There should be no desktop profile, no additional packages, no disk encryption,
and no Archinstall-managed ZRAM swap.

Because UKI is enabled, the persistent NVMe kernel parameter should later be
added to `/etc/kernel/cmdline`; see the troubleshooting guide.

The repo bootstrap will install/configure PipeWire, ZRAM, networking services,
Niri/Noctalia and the rest of the system after the base Arch install.

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
