# Current CachyOS baseline

This is a deliberately non-sensitive summary of the old system, used only to guide the Arch migration.

## Desktop

- CachyOS
- Niri + Noctalia
- Noctalia Greeter via greetd
- Fish
- Kitty
- Wayland
- Xwayland Satellite
- GNOME + GTK desktop integrations where useful

## Hardware / graphics

- AMD Ryzen 7 3700U
- AMD Picasso/Raven Vega integrated GPU
- AMD Topaz XT discrete Radeon GPU
- both GPUs use `amdgpu`
- Intel AC 3168 Wi-Fi
- Realtek RTL8111/8168-series Ethernet

## Storage

- Btrfs root filesystem
- separate Btrfs subvolumes for home, root, srv, cache, tmp and log
- ZRAM swap
- no Snapper configuration on the old installation

## Services currently relied on

- NetworkManager
- Bluetooth
- greetd
- UFW
- fstrim timer
- systemd-resolved
- systemd-timesyncd
- PipeWire / WirePlumber
- GNOME Keyring user socket

## Intentionally not reproduced automatically

- CachyOS repositories
- CachyOS kernel
- CachyOS Ananicy rules
- CachyOS package/kernel managers
- CachyOS Plymouth/theme packages
- CachyOS sysctl / udev / scheduler tuning

These can be revisited individually if a real regression appears after migration.
