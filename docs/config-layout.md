# Configuration layout

Keep configuration in the narrowest useful scope:

- `dotfiles/`: portable user configuration
- `hosts/`: hardware-specific configuration
- `system/`: files installed under `/etc`
- `packages/`: software dependencies
- `install/`: commands that apply those pieces

Example:

- generic Niri keybind → `dotfiles/niri/`
- HDMI-A-1 monitor layout → `hosts/acer-laptop/`
- ZRAM config → `system/`

This keeps a future second machine from inheriting laptop-specific settings.
