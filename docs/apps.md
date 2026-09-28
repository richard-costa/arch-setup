# Application setup

Only settings that are not already represented by package manifests or dotfiles
are kept here.

## Firefox PWA

The native component is installed by `firefoxpwa`.

Also install the Firefox extension:

https://addons.mozilla.org/en-US/firefox/addon/pwas-for-firefox/

If a PWA gets a white/light titlebar or border on Linux:

1. press `Ctrl+L` in the PWA window
2. open `about:config`
3. set `firefoxpwa.sitesSetThemeColor` to `false`

PWAsForFirefox documents this preference as allowing sites to override the
window theme/titlebar color and notes that it can cause problems on some Linux
desktop environments.

## Firefox / Noctalia palette

The Noctalia first-install seed enables the community template `pywalfox`.
Firefox still needs the **Pywalfox** browser extension installed once. No
separate Python `pywalfox` package is needed.

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

KWrite is the graphical default for plain/empty text files. On Arch it is
provided by the `kate` package:

```bash
gio mime text/plain org.kde.kwrite.desktop
gio mime application/x-zerosize org.kde.kwrite.desktop
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

The first-install Noctalia seed enables the Yazi template, and the tracked
`colors_changed = "ya emit-to 0 app:theme"` hook refreshes Yazi when the palette
changes.

## PDF / ebook tools

The package list includes Okular, Poppler utilities, qpdf, img2pdf,
ImageMagick, MuPDF tools, ebook-tools and kdegraphics-mobipocket.

## Markdown editor

Apostrophe is installed as the normal Markdown editor.
