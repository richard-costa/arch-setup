# Noctalia personalization

Noctalia is seeded automatically on the first install so the normal workstation
appearance does not need to be rebuilt manually in the GUI.

## Where settings live

- Stable config: `~/.config/noctalia/config.toml`
- GUI-managed settings: `~/.local/state/noctalia/settings.toml`
- Runtime/internal state: `~/.local/state/noctalia/state.toml`

The repository does not track the live `settings.toml` or `state.toml` directly.
Instead, `defaults/noctalia-settings.toml` is copied to `settings.toml` only when
that file does not already exist. After the copy, Noctalia owns the file and GUI
changes work normally.

The bootstrap never overwrites an existing `settings.toml`.

## Stable config

These integration settings are tracked in `dotfiles/noctalia/` and deployed to
`~/.config/noctalia/config.toml`:

```toml
[shell]
polkit_agent = true

[hooks]
colors_changed = "ya emit-to 0 app:theme"
```

The color-change hook tells Yazi to refresh its theme whenever Noctalia changes
the wallpaper-derived palette.

`dotfiles/yazi/.config/yazi/theme.toml` selects Noctalia's generated Yazi theme.

## First-install Noctalia seed

The first-install seed configures:

- wallpaper-derived colors
- M3 tonal-spot wallpaper scheme
- colorized application icons
- built-in GTK 3, GTK 4, KColorScheme, Kitty, Niri and Btop templates
- community Pywalfox, Obsidian, VS Code, Fastfetch and Yazi templates
- wallpaper directory `~/Pictures/Wallpapers`
- wallpaper automation every 600 seconds / 10 minutes
- default bar layout
- official `noctalia/mpvpaper` plugin and bar widget
- mpvpaper video directory `~/Videos`
- automatic location by IP
- automatic greeter appearance sync

The seed intentionally does not store the currently selected wallpaper,
per-monitor wallpaper choices, lockscreen geometry, runtime state, or secrets.

## Templates

Built-in:

- GTK 3
- GTK 4
- KColorScheme
- Kitty
- Niri
- Btop

Community:

- Pywalfox
- Obsidian
- VS Code
- Fastfetch
- Yazi

The Alacritty and Cava templates are not needed for this workstation.

For Qt applications, `qt6ct-kde` is installed and Niri exports
`QT_QPA_PLATFORMTHEME=qt6ct`. The KColorScheme template generates the Noctalia
scheme, but qt6ct still needs to select `noctalia (KColorScheme)` once unless its
own config is later made reproducible too.

Noctalia writes generated colors outside the repository. The tracked configs only contain stable integration points:

- Niri includes `noctalia.kdl`
- Kitty includes `themes/noctalia.conf`

Generated files include:

```text
~/.config/niri/noctalia.kdl
~/.config/kitty/themes/noctalia.conf
```

## Wallpapers

The repository keeps the shareable/source collections:

```text
wallpapers/        static wallpapers
video-wallpapers/  mpvpaper/video wallpapers
```

`install/media.sh` copies them into:

```text
~/Pictures/Wallpapers
~/Videos
```

Using copies is intentional: the Git repository remains the curated/shareable
source collection while Noctalia and mpvpaper use normal home-directory paths.

The exact current/last wallpaper is runtime state and is not fixed by the seed.

## Bar

Current default bar layout:

```text
start:  launcher, workspaces
center: wallpaper, mpvpaper, clock
```

## Plugins

Currently enabled:

- `noctalia/mpvpaper`

Its video directory defaults to `~/Videos`.

## Location

Automatic location by IP is enabled by the first-install seed.

## Lockscreen widgets

Custom lockscreen-widget configuration currently exists for both:

- `eDP-1`
- `HDMI-A-1`

The feature is currently disabled. These placements are monitor-specific and
are not reproduced automatically.

## Greeter sync

Automatic appearance sync is enabled by the first-install seed.

To allow appearance-only greeter sync without repeated sudo prompts:

```bash
sudo noctalia-greeter passwordless-sync enable "$USER"
```

This creates the dedicated Polkit permission supported by Noctalia Greeter; it
does not grant general passwordless sudo access.

## Re-applying the seed manually

The normal installer seeds Noctalia only when
`~/.local/state/noctalia/settings.toml` does not exist.

To deliberately replace the current GUI settings with the repository seed,
back up the current file first, then rerun the dotfile installer:

```bash
mkdir -p ~/.local/state/noctalia
mv ~/.local/state/noctalia/settings.toml \
   ~/.local/state/noctalia/settings.toml.backup 2>/dev/null || true
bash install/dotfiles.sh
```

Afterward, log out/in or restart Noctalia so all templates and plugin state are
applied.
