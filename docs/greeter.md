# Noctalia Greeter

Noctalia Greeter runs through **greetd**.

The repository keeps the stable greetd config under:

```text
system/greetd/config.toml
```

Apply it with:

```bash
bash install/greeter.sh
```

That script:

1. installs the repository's greetd config
2. runs Noctalia Greeter's upstream system-setup helper when available
3. adds GNOME Keyring auto-unlock to `/etc/pam.d/greetd`
4. enables greetd for the next boot

It does **not** start greetd immediately.

## GNOME Keyring

The login keyring should normally use the same password as the Linux account.
PAM can then unlock it during login.

The relevant PAM lines are:

```text
auth       optional     pam_gnome_keyring.so
session    optional     pam_gnome_keyring.so auto_start
```

The greeter package/upstream helper may add other PAM entries needed for the
runtime directory. Do not replace the whole PAM file with a hardcoded copy.

## Appearance sync

Noctalia's GUI setting `shell.greeter_sync.auto_sync = true` is preferred.
Greeter appearance state under `/var/lib/noctalia-greeter` is generated
machine state and is not tracked in this repository.

## Recovery

The first time the script replaces greetd's stock config it saves:

```text
/etc/greetd/config.toml.pre-arch-workstation
```

If the graphical greeter fails, switch to another TTY and inspect:

```bash
systemctl status greetd
journalctl -b -u greetd
```
