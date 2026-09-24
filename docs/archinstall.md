# Archinstall choices

Use the minimal profile rather than Archinstall's Niri desktop profile.

Recommended choices:

- Profile: **Minimal**
- Kernel: **linux-zen**
- Networking: **NetworkManager**
- Audio: **PipeWire**
- Filesystem: **Btrfs**
- Btrfs default subvolume layout: **yes**
- Disk encryption: **no** (current preference)
- Desktop environment / window manager: **none**
- Multilib: **enabled**
- Bootloader: choose normally in Archinstall
- Swap: disk swap optional; ZRAM is configured by this repository

After first boot:

```bash
git clone <repo-url>
cd arch-workstation

bash install/base.sh
bash install/desktop.sh
bash install/extras.sh
bash install/aur.sh
bash install/system.sh
bash install/services.sh
bash install/dotfiles.sh
bash install/host.sh acer-laptop
```

Notes:

- `packages/extras.txt` is intentionally optional.
- `packages/aur.txt` currently contains the Noctalia Greeter.
- No SSH server is enabled; `openssh` is installed for Git/SSH client use.
- CUPS and cron are not installed by default.
- Snapper packages are listed as optional, but snapshot configuration is not automated yet.
