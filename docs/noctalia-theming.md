# Noctalia theming

Noctalia is the source of truth for colors.

The wallpaper rotates, Noctalia derives a palette, and its built-in templates render application-specific files.

Generated files are intentionally **not committed**:

- `~/.config/niri/noctalia.kdl`
- `~/.config/kitty/themes/noctalia.conf`

The stable integration points **are committed**:

- Niri includes `noctalia.kdl`
- Kitty includes `themes/noctalia.conf`

After a fresh install, enable Noctalia's built-in **Niri** and **Kitty** templates in Noctalia Settings → Templates.

This keeps the repository independent of whichever wallpaper happens to be active when a commit is made.
