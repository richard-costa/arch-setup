# Dotfiles

GNU Stow deploys portable user configuration:

- `niri/`: compositor, keybinds, input, layout and rules.
- `fish/`: shell conveniences.
- `kitty/`: Meslo Nerd Font terminal and Noctalia theme include.
- `noctalia/`: stable integration configuration.
- `yazi/`: Noctalia-generated theme selection.

First-run preferences are copied only if absent, not stowed, so applications can rewrite them:

| Seed under `defaults/` | Destination |
|---|---|
| `noctalia-settings.toml` | `~/.local/state/noctalia/settings.toml` |
| `qt6ct.conf` | `~/.config/qt6ct/qt6ct.conf` |
| `fastfetch-config.jsonc` | `~/.config/fastfetch/config.jsonc` |

`install/dotfiles.sh` applies GTK/GNOME appearance and fonts via `gsettings`. Generated colors and runtime/internal state are not tracked.
