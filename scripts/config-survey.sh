#!/usr/bin/env bash

# Print the configuration files we need to review for migration.
#
# This script is intentionally selective. It does not dump all of ~/.config.
# It also redacts the current username, hostname and absolute home path.
#
# Review the output before sharing it publicly.
set -u

section() {
  printf '\n\n===== %s =====\n' "$1"
}

redact() {
  sed \
    -e "s|$HOME|~|g" \
    -e "s|${USER:-user}|[user]|g" \
    -e "s|$(hostname)|[host]|g"
}

show_file() {
  local file="$1"

  if [[ ! -f "$file" ]]; then
    return
  fi

  printf '\n--- %s ---\n' "${file/#$HOME/~}"
  redact < "$file"
}

section "NIRI"

# Niri configuration is generally safe and is the most important desktop
# configuration to migrate. Show the main file and CachyOS modular fragments.
show_file "$HOME/.config/niri/config.kdl"

for file in "$HOME"/.config/niri/cfg/*.kdl; do
  [[ -e "$file" ]] || continue
  show_file "$file"
done

show_file "$HOME/.config/niri/noctalia.kdl"

section "FISH"

# config.fish may contain useful aliases/functions. fish_variables is generated
# state and can contain universal variables, so list its variable names only.
show_file "$HOME/.config/fish/config.fish"

if [[ -f "$HOME/.config/fish/fish_variables" ]]; then
  printf '\n--- ~/.config/fish/fish_variables (names only) ---\n'
  sed -nE 's/^SETUVAR[^:]*:([^:]+):.*/\1/p' \
    "$HOME/.config/fish/fish_variables" | sort -u
fi

section "KITTY"

show_file "$HOME/.config/kitty/kitty.conf"

# Theme files are safe to inspect and useful for recreating Noctalia theming.
for file in "$HOME"/.config/kitty/themes/*.conf; do
  [[ -e "$file" ]] || continue
  show_file "$file"
done

section "NOCTALIA"

# Noctalia may store location/widget data. Do not print values automatically.
# Only show the names of TOML sections/keys so we know what is customized.
if [[ -f "$HOME/.config/noctalia/config.toml" ]]; then
  printf '\n--- ~/.config/noctalia/config.toml (keys only) ---\n'
  sed -E \
    -e '/^[[:space:]]*(#|$)/d' \
    -e 's/^([[:space:]]*\[[^]]+\]).*/\1/' \
    -e 's/^([[:space:]]*[A-Za-z0-9_.-]+)[[:space:]]*=.*/\1 = [redacted]/' \
    "$HOME/.config/noctalia/config.toml"
fi

section "WIREPLUMBER / PIPEWIRE"

# Audio configuration can contain the headset channel fix we want to preserve.
# Only print user-created config files; if none exist, say so.
found_audio=false
for dir in "$HOME/.config/wireplumber" "$HOME/.config/pipewire"; do
  [[ -d "$dir" ]] || continue

  while IFS= read -r -d '' file; do
    found_audio=true
    show_file "$file"
  done < <(find "$dir" -type f -print0 2>/dev/null)
done

if [[ "$found_audio" == false ]]; then
  echo "No user WirePlumber/PipeWire config files found."
fi

section "END"
echo "Review the output before sharing."
