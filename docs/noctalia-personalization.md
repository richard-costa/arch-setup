# Noctalia personalization

The bootstrap seeds Noctalia on the first install so the normal workstation
appearance does not need to be rebuilt manually in the GUI.

## How it works

- Stable integrations live in `~/.config/noctalia/config.toml`.
- GUI-managed preferences live in `~/.local/state/noctalia/settings.toml`.
- Internal/runtime state lives in `~/.local/state/noctalia/state.toml`.

The repository does not track the live `settings.toml`. Instead,
`defaults/noctalia-settings.toml` is copied there only when the file does not
already exist. After that first copy, Noctalia owns the file and later GUI
changes work normally. Re-running the bootstrap never overwrites an existing
`settings.toml`.

## Stable integrations

Tracked in `dotfiles/noctalia/.config/noctalia/config.toml`:

```toml
[shell]
polkit_agent = true

[hooks]
colors_changed = "ya emit-to 0 app:theme"
```

The hook refreshes Yazi when Noctalia changes its generated palette.
`dotfiles/yazi/.config/yazi/theme.toml` selects the generated Noctalia flavor.

## First-install seed

The seed configures:

- wallpaper-derived colors with the M3 tonal-spot scheme
- colorized application icons
- wallpaper directory `~/Pictures/Wallpapers`
- wallpaper fill mode `fit` with `shadow` as the uncovered-area fill color
- wallpaper rotation every 600 seconds / 10 minutes
- bar layout: `launcher, workspaces` at start and `wallpaper, mpvpaper, clock` in center
- built-in templates: GTK 3, GTK 4, KColorScheme, Kitty, Niri and Btop
- community templates: Pywalfox, Obsidian, VS Code, Fastfetch and Yazi
- official `noctalia/mpvpaper` plugin and bar widget
- mpvpaper video directory `~/Videos`
- automatic location by IP
- automatic greeter appearance sync

Noctalia exposes application-icon tinting in **Settings → Appearance → Interface → Colorize App Icons**.

The seed intentionally does not store the currently selected wallpaper,
per-monitor wallpaper choices, lockscreen geometry, runtime state, or secrets.

## Wallpapers and video wallpapers

`install/media.sh` copies the repository collections into:

```text
wallpapers/        -> ~/Pictures/Wallpapers/
video-wallpapers/  -> ~/Videos/
```

The Git repository remains the curated source; Noctalia and mpvpaper use the
normal home-directory copies.

## Qt / KColorScheme

`qt6ct-kde` is installed and Niri exports `QT_QPA_PLATFORMTHEME=qt6ct`.
Noctalia's KColorScheme template generates the color scheme automatically.

One manual step remains unless qt6ct itself is later made reproducible: run
`qt6ct`, select **`noctalia (KColorScheme)`** under **Appearance → Color scheme**,
and apply it.

## Generated theme files

Noctalia owns generated colors. Examples include:

```text
~/.config/niri/noctalia.kdl
~/.config/kitty/themes/noctalia.conf
```

These are not committed.

## Lockscreen widgets

Monitor-specific lockscreen widget placements currently exist for `eDP-1` and
`HDMI-A-1`, but the feature is disabled. They are deliberately not reproduced
because their coordinates depend on the monitor arrangement.

## Greeter sync permission

Automatic greeter appearance sync is seeded. To allow the constrained sync
operation without repeated password prompts:

```bash
sudo noctalia-greeter passwordless-sync enable "$USER"
```

This grants only Noctalia Greeter's appearance-sync Polkit action, not general
passwordless sudo.

## Re-applying the seed manually

The normal installer only seeds when `settings.toml` is absent. To deliberately
replace current GUI preferences with the repository defaults:

```bash
mkdir -p ~/.local/state/noctalia
mv ~/.local/state/noctalia/settings.toml \
   ~/.local/state/noctalia/settings.toml.backup 2>/dev/null || true
bash install/dotfiles.sh
```

Then restart Noctalia or log out/in.
