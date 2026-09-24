# Application setup

Only settings that are not already represented by package manifests or dotfiles
are kept here.

## Firefox PWA

The native component is installed by `firefoxpwa`.

Also install the Firefox extension:

https://addons.mozilla.org/en-US/firefox/addon/pwas-for-firefox/

A previous setup also needed an `about:config` preference changed to `false`
to remove a white PWA window border, but the preference name was not recorded.
Do not guess it; add it here if the issue reappears and the exact setting is
identified.

## Firefox / Noctalia palette

Working setup:

1. install the **Pywalfox** Firefox extension
2. enable Noctalia community template `pywalfox-beta4`
3. restart Firefox once

No separate Python `pywalfox` package is needed for this setup.

## Flatpak / Stremio

Flatpak is installed with the desktop packages.

Install Stremio from Flathub when wanted:

```bash
flatpak install flathub com.stremio.Stremio
```

## Default image viewer

Use Loupe for common image types:

```bash
xdg-mime default org.gnome.Loupe.desktop image/png
xdg-mime default org.gnome.Loupe.desktop image/jpeg
xdg-mime default org.gnome.Loupe.desktop image/webp
```

## Default text editor

GNOME Text Editor is the graphical default for plain/empty text files:

```bash
gio mime text/plain org.gnome.TextEditor.desktop
gio mime application/x-zerosize org.gnome.TextEditor.desktop
```

Micro remains the terminal editor through the Fish `EDITOR` and `VISUAL`
variables.

`xdg-terminal-exec` is installed so desktop applications can request the
preferred terminal when launching terminal-oriented applications.

## Yazi

Useful copy workflow:

```text
Space   select
y       copy / yank
p       paste in the destination directory
```

Noctalia's Yazi template is refreshed by the tracked
`colors_changed = "ya emit-to 0 app:theme"` hook.

## PDF / ebook tools

The package list includes:

- Okular for viewing
- Poppler utilities
- qpdf
- img2pdf
- ImageMagick
- MuPDF tools
- ebook-tools
- kdegraphics-mobipocket

These cover the PDF manipulation workflow plus EPUB/MOBI support in the KDE
document stack.

## Markdown editors

Apostrophe is installed as the normal Markdown editor.

`marktext-bin` is kept commented in `packages/aur.txt` as an alternative,
not installed by default.
