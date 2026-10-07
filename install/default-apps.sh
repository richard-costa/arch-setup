#!/usr/bin/env bash

# Set workstation-wide user defaults for opening common text files.
#
# KWrite is the lightweight graphical editor for plain/empty files.
# Typora is the default Markdown editor. Micro remains EDITOR/VISUAL in Fish.
set -euo pipefail

if ! command -v xdg-mime >/dev/null 2>&1; then
    echo "error: xdg-mime is not installed (provided by xdg-utils)." >&2
    exit 1
fi

desktop_exists() {
    local desktop="$1"
    [[ -f "/usr/share/applications/$desktop" ||
       -f "${XDG_DATA_HOME:-$HOME/.local/share}/applications/$desktop" ]]
}

set_default() {
    local desktop="$1"
    shift

    local mime
    for mime in "$@"; do
        xdg-mime default "$desktop" "$mime"
    done
}

if desktop_exists org.kde.kwrite.desktop; then
    set_default org.kde.kwrite.desktop text/plain application/x-zerosize
else
    echo "warning: KWrite desktop entry not found; skipping plain-text defaults." >&2
fi

# The AUR package normally installs typora.desktop. Keep the Flatpak-style ID
# as a fallback so this remains useful if the packaging changes later.
typora_desktop=""
for candidate in typora.desktop io.typora.Typora.desktop; do
    if desktop_exists "$candidate"; then
        typora_desktop="$candidate"
        break
    fi
done

if [[ -n "$typora_desktop" ]]; then
    set_default "$typora_desktop" text/markdown text/x-markdown
else
    echo "warning: Typora desktop entry not found; skipping Markdown defaults." >&2
fi

echo "Default application associations configured."
