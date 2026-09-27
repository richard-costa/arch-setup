# Btrfs snapshots

Use **Btrfs Assistant** rather than a custom setup script.

Install the optional extras:

```bash
bash install/extras.sh
```

Then open **Btrfs Assistant** and create/manage a Snapper configuration for `/`.

Relevant packages:

- `btrfs-assistant` — GUI
- `snapper` — snapshot backend
- `snap-pac` — snapshots around pacman transactions

The Archinstall layout keeps `/home` in a separate Btrfs subvolume, so root
snapshots do not automatically roll personal files backward.

## Btrfs Assistant: passwordless Polkit authorization

Btrfs Assistant launches its privileged backend through Polkit. To allow only
this action for the `richard` user without a password prompt, first verify the
action ID:

```bash
pkaction | grep -i btrfs
```

Expected output:

```text
org.btrfs-assistant.pkexec.policy.run
```

Create a local Polkit rule:

```bash
sudo micro /etc/polkit-1/rules.d/49-btrfs-assistant.rules
```

`nano` can be used instead of `micro` if it is installed:

```bash
sudo nano /etc/polkit-1/rules.d/49-btrfs-assistant.rules
```

Add:

```javascript
polkit.addRule(function(action, subject) {
    if (action.id == "org.btrfs-assistant.pkexec.policy.run" &&
        subject.user == "richard") {
        return polkit.Result.YES;
    }
});
```

Reload Polkit:

```bash
sudo systemctl restart polkit
```

This grants passwordless authorization only for the Btrfs Assistant Polkit
action above; it does not make other administrative GUI actions passwordless.

## Useful CLI inspection

```bash
sudo snapper list-configs
sudo snapper -c root list
sudo btrfs subvolume list /
```

Rollback is intentionally not automated by this repository.
