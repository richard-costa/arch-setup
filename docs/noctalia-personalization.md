# Noctalia personalization

Noctalia is intentionally managed through its GUI rather than by install scripts.

The repository documents the desired setup, but does **not** try to overwrite
Noctalia's runtime settings automatically.

## Where settings live

- Stable config: `~/.config/noctalia/config.toml`
- GUI-managed settings: `~/.local/state/noctalia/settings.toml`
- Runtime/internal state: `~/.local/state/noctalia/state.toml`

Do not commit `settings.toml` or `state.toml` directly. They can contain
machine-specific state and plugin secrets.

## Stable config

Keep these settings in `~/.config/noctalia/config.toml`:

```toml
[shell]
polkit_agent = true

[hooks]
colors_changed = "ya emit-to 0 app:theme"
```

The color-change hook tells Yazi to refresh its theme whenever Noctalia changes
the wallpaper-derived palette.

## Theme

Current intent:

- dark mode
- wallpaper-derived colors
- Ayu built-in palette base
- M3 tonal-spot wallpaper scheme
- application icons colorized
- greeter sync enabled

Noctalia is the source of truth for colors. Do not commit generated palette
files.

## Templates

Keep these enabled:

### Built-in

- GTK 3
- GTK 4
- KColorScheme
- Kitty
- Niri
- Btop

### Community

- Pywalfox
- Obsidian
- VS Code
- Fastfetch
- Yazi

The Alacritty and Cava templates are not needed for this workstation.

Generated files such as these should remain untracked:

```text
~/.config/niri/noctalia.kdl
~/.config/kitty/themes/noctalia.conf
```

## Wallpaper rotation

Wallpaper directory:

```text
~/Pictures/Wallpapers
```

Automation:

- enabled
- rotate every 600 seconds / 10 minutes
- theme source follows the wallpaper

The exact current/last wallpaper does not belong in the repository because it
changes automatically.

## Bar

Current default bar layout:

```text
start:  launcher, workspaces
center: wallpaper, mpvpaper, clock
```

## Plugins

Currently enabled:

- `noctalia/mpvpaper`

Wallhaven is configured but its API key is a secret. Never place that key in
Git, documentation, dotfiles, screenshots, or shell history intended for
sharing.

If the Wallhaven plugin is used again, configure its API key manually through
Noctalia after installation.

## Location

Automatic location detection is enabled.

Because location is personal/machine state, configure this through the GUI
rather than storing resolved location values in Git.

## Lockscreen widgets

Custom lockscreen-widget configuration currently exists for both:

- `eDP-1`
- `HDMI-A-1`

The feature is currently disabled.

These placements are monitor-specific and should be adjusted through Noctalia's
GUI if the monitor arrangement changes rather than being automated by this
repository.

## After a fresh install

Open Noctalia Settings and verify:

1. wallpaper directory and automatic rotation
2. Niri / Kitty / GTK / KColorScheme templates
3. community templates used by installed applications
4. bar widget layout
5. mpvpaper plugin
6. greeter sync
7. automatic location
8. any plugin secrets entered manually

The repository should document intent; Noctalia should remain responsible for
its own generated state and colors.
