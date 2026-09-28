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
- Noctalia interface font `Noto Sans`
- colorized application icons using `on_surface_variant`
- wallpaper directory `~/Pictures/Wallpapers`
- wallpaper fill mode `fit` with `shadow` as the uncovered-area fill color
- wallpaper rotation every 600 seconds / 10 minutes
- bar layout: `launcher, workspaces` at start and `wallpaper, mpvpaper, clock` in center
- built-in templates: GTK 3, GTK 4, KColorScheme, Qt, Kitty, Niri and Btop
- community templates: Pywalfox, Obsidian, VS Code, Fastfetch and Yazi
- official `noctalia/mpvpaper` plugin and bar widget
- mpvpaper video directory `~/Videos`
- automatic location by IP
- automatic greeter appearance sync

Noctalia exposes the relevant interface settings under **Settings → Appearance → Interface**.

The seed intentionally does not store the currently selected wallpaper,
per-monitor wallpaper choices, lockscreen geometry, runtime state, or secrets.

## Fonts

The workstation uses two coordinated font roles:

```text
Noctalia / GTK / Qt UI   Noto Sans 11
Kitty / terminal apps    MesloLGS Nerd Font Mono 11
```

`install/dotfiles.sh` applies `Noto Sans 11` to GTK/GNOME interface and document
fonts and `MesloLGS Nerd Font Mono 11` to the GTK monospace preference. Kitty
tracks the same Meslo font directly in its dotfile. The Noctalia first-install
seed selects `Noto Sans` for shell UI.

For Qt, `defaults/qt6ct.conf` seeds those same font choices only when
`~/.config/qt6ct/qt6ct.conf` does not already exist. Existing qt6ct preferences
are never overwritten by the bootstrap.

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
Noctalia enables both its Qt and KColorScheme built-in templates so wallpaper
palette changes generate colors for qt5ct/qt6ct as well as KDE applications.
The bootstrap seeds the Qt fonts, but one manual appearance step remains:
run `qt6ct`, select **`noctalia (KColorScheme)`** under **Appearance → Color scheme**,
and apply it.

## Fastfetch

`defaults/fastfetch-config.jsonc` is copied once to
`~/.config/fastfetch/config.jsonc`. It stores the selected system-information
modules, adds one blank line before the text, and sets one line of top padding
on the Arch logo so both columns have matching vertical spacing.

The config intentionally does not hard-code Fastfetch colors. Noctalia's
Fastfetch community template remains responsible for the active palette.
It generates `~/.config/fastfetch/themes/noctalia.jsonc` from the wallpaper
colors and its hook merges the generated logo/display colors into the main
Fastfetch configuration. `jq` is installed because that hook uses it. Existing
`config.jsonc` files are left untouched by later bootstrap runs.

## Generated theme files

Noctalia owns generated colors. Examples include:

```text
~/.config/niri/noctalia.kdl
~/.config/kitty/themes/noctalia.conf
~/.config/fastfetch/themes/noctalia.jsonc
```

These generated files are not committed.

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
