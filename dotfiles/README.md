# Dotfiles

Portable user configuration deployed with GNU Stow:

- `niri/` — compositor, keybinds, input, layout and rules
- `fish/` — shell conveniences
- `kitty/` — Meslo Nerd Font terminal config and Noctalia theme include
- `noctalia/` — stable Noctalia integration config
- `yazi/` — Noctalia-generated theme selection

Some application preferences are seeded rather than stowed because the
applications are expected to own and rewrite those files after first launch:

- `defaults/noctalia-settings.toml` → `~/.local/state/noctalia/settings.toml`
- `defaults/qt6ct.conf` → `~/.config/qt6ct/qt6ct.conf`
- `defaults/fastfetch-config.jsonc` → `~/.config/fastfetch/config.jsonc`

Each seed is copied only when the destination does not already exist. Existing
Noctalia, qt6ct and Fastfetch preferences are therefore preserved on later
bootstrap runs.

GTK/GNOME appearance and font preferences are applied with `gsettings` by
`install/dotfiles.sh`.

Generated colors and runtime/internal state are intentionally not tracked.
