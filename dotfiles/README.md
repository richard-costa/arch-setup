# Dotfiles

Portable user configuration deployed with GNU Stow:

- `niri/` — compositor, keybinds, input, layout and rules
- `fish/` — shell conveniences
- `kitty/` — terminal config and Noctalia theme include
- `noctalia/` — stable Noctalia integration config
- `yazi/` — Noctalia-generated theme selection

Noctalia's live GUI-managed state is not stowed. On a fresh install,
`defaults/noctalia-settings.toml` is copied once to
`~/.local/state/noctalia/settings.toml`; after that, Noctalia owns and updates
that file normally.

Generated colors and runtime/internal state are intentionally not tracked.
