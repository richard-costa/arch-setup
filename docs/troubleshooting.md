# Troubleshooting

## NVMe boot issue

On the previous CachyOS installation, the machine required this kernel parameter
to boot reliably:

```text
nvme_core.default_ps_max_latency_us=5500
```

Do **not** add it preemptively on the new Arch installation.

If the same NVMe boot problem appears again, add that parameter to the kernel
command line using the bootloader selected during Archinstall, then regenerate
that bootloader's entries if required.

The previous working CachyOS commands edited `/etc/sdboot-manage.conf` and ran
`sdboot-manage gen`. Those commands are CachyOS-specific and are intentionally
not part of this vanilla Arch setup.
