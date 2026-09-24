# Troubleshooting

## NVMe boot parameter

This laptop consistently needs the following Linux kernel parameter:

```text
nvme_core.default_ps_max_latency_us=5500
```

This is not CachyOS-specific. Add it when booting the installer **and** make it
persistent in the installed system.

### Arch installation ISO

On UEFI systems the Arch ISO uses systemd-boot.

1. boot the Arch USB
2. select the Arch Linux install entry
3. press `e`
4. append `nvme_core.default_ps_max_latency_us=5500` to the kernel command line
5. press Enter to boot

If the systemd-boot menu does not stay visible, hold Space while booting.

### Installed system

Add the same parameter permanently using the bootloader selected in Archinstall.

For systemd-boot with a normal loader entry, append it to the `options` line
in the Arch entry under:

```text
/boot/loader/entries/
```

For a unified kernel image (UKI), add it to:

```text
/etc/kernel/cmdline
```

For GRUB, append it inside `GRUB_CMDLINE_LINUX_DEFAULT` in:

```text
/etc/default/grub
```

then regenerate the configuration:

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

Verify after booting:

```bash
cat /proc/cmdline
```

The old CachyOS procedure using `/etc/sdboot-manage.conf` and
`sdboot-manage gen` is intentionally not used on vanilla Arch.
