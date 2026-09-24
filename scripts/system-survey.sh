#!/usr/bin/env bash
set -u

section() {
  printf '\n\n===== %s =====\n' "$1"
}

run() {
  printf '\n$ %s\n' "$*"
  "$@" 2>&1 || true
}

have() {
  command -v "$1" >/dev/null 2>&1
}

pkg_version() {
  for pkg in "$@"; do
    pacman -Q "$pkg" 2>/dev/null || true
  done
}

service_state() {
  for unit in "$@"; do
    printf '%-36s enabled=%-12s active=%s\n' \
      "$unit" \
      "$(systemctl is-enabled "$unit" 2>/dev/null || echo n/a)" \
      "$(systemctl is-active "$unit" 2>/dev/null || echo n/a)"
  done
}

user_service_state() {
  for unit in "$@"; do
    printf '%-36s enabled=%-12s active=%s\n' \
      "$unit" \
      "$(systemctl --user is-enabled "$unit" 2>/dev/null || echo n/a)" \
      "$(systemctl --user is-active "$unit" 2>/dev/null || echo n/a)"
  done
}

safe_file_inventory() {
  local dir
  for dir in "$@"; do
    if [[ -d "$dir" ]]; then
      printf '\n[%s]\n' "${dir/#$HOME/~}"
      find "$dir" -maxdepth 3 -type f -printf '%p\n' 2>/dev/null \
        | sed "s|^$HOME|~|" \
        | sort
    fi
  done
}

section "PRIVACY NOTE"
cat <<'EOF'
This survey intentionally avoids:
- IP addresses and Wi-Fi SSIDs
- MAC addresses
- disk UUIDs and serial numbers
- SSH keys / credentials / tokens
- browser and keyring contents
- arbitrary dotfile contents

Still review the output before posting it publicly.
EOF

section "SYSTEM"
printf 'OS: '
awk -F= '/^PRETTY_NAME=/{gsub(/^"|"$/, "", $2); print $2}' /etc/os-release 2>/dev/null || true
printf 'Kernel: '
uname -srmo
printf 'Shell: %s\n' "${SHELL:-unknown}"
printf 'Desktop: %s\n' "${XDG_CURRENT_DESKTOP:-unknown}"
printf 'Session type: %s\n' "${XDG_SESSION_TYPE:-unknown}"
printf 'Wayland display: %s\n' "${WAYLAND_DISPLAY:-unknown}"
printf 'QT_QPA_PLATFORMTHEME: %s\n' "${QT_QPA_PLATFORMTHEME:-unset}"
printf 'NTP enabled: '
timedatectl show -p NTP --value 2>/dev/null || true
printf 'NTP synchronized: '
timedatectl show -p NTPSynchronized --value 2>/dev/null || true

section "PACMAN REPOSITORIES"
if have pacman-conf; then
  run pacman-conf --repo-list
else
  grep -E '^\[[^]]+\]$' /etc/pacman.conf 2>/dev/null || true
fi

section "KEY PACKAGE VERSIONS"
pkg_version \
  linux linux-zen linux-lts linux-cachyos \
  niri noctalia cachyos-niri-noctalia xwayland-satellite \
  xdg-desktop-portal xdg-desktop-portal-gnome xdg-desktop-portal-gtk \
  greetd noctalia-greeter sddm gdm lightdm \
  gnome-keyring libsecret \
  pipewire pipewire-pulse pipewire-alsa wireplumber \
  networkmanager iwd bluez bluez-utils \
  upower power-profiles-daemon \
  mesa vulkan-radeon lib32-mesa lib32-vulkan-radeon \
  steam \
  fish kitty firefox nautilus gvfs \
  zram-generator snapper snap-pac \
  ufw firewalld \
  cachyos-settings ananicy-cpp

section "EXPLICITLY INSTALLED PACKAGES"
pacman -Qqe 2>/dev/null || true

section "FOREIGN / AUR PACKAGES"
pacman -Qqem 2>/dev/null || true

section "CACHYOS-SPECIFIC PACKAGES"
pacman -Qq 2>/dev/null \
  | grep -Ei '(^cachyos|cachy|linux-cachyos|proton-cachyos|wine-cachyos|ananicy)' \
  || true

section "ENABLED SYSTEM SERVICES"
systemctl list-unit-files --state=enabled --no-pager --no-legend 2>/dev/null || true

section "ENABLED USER SERVICES"
systemctl --user list-unit-files --state=enabled --no-pager --no-legend 2>/dev/null || true

section "IMPORTANT SERVICE STATES"
service_state \
  NetworkManager.service \
  bluetooth.service \
  power-profiles-daemon.service \
  greetd.service sddm.service gdm.service lightdm.service \
  fstrim.timer paccache.timer pkgfile-update.timer \
  ufw.service firewalld.service \
  cups.service cronie.service sshd.service \
  apparmor.service

section "IMPORTANT USER SERVICE STATES"
user_service_state \
  xdg-desktop-portal.service \
  xdg-desktop-portal-gnome.service \
  xdg-desktop-portal-gtk.service \
  pipewire.service pipewire-pulse.service wireplumber.service

section "FILESYSTEM / MOUNTS"
run lsblk -o NAME,TYPE,FSTYPE,SIZE,MOUNTPOINTS
printf '\nMount targets/options (sources omitted):\n'
findmnt -rn -o TARGET,FSTYPE,OPTIONS 2>/dev/null || true

if findmnt -n -o FSTYPE / 2>/dev/null | grep -q btrfs; then
  printf '\nBtrfs subvolumes:\n'
  sudo btrfs subvolume list / 2>/dev/null || true
fi

section "SWAP / ZRAM"
run swapon --show --output=NAME,TYPE,SIZE,USED,PRIO
if have zramctl; then
  run zramctl
fi

section "CPU / GPU / RELEVANT HARDWARE"
if have lscpu; then
  lscpu 2>/dev/null | grep -E '^(Architecture|CPU\(s\)|Model name|Vendor ID|Virtualization):' || true
fi
printf '\nPCI graphics/audio/network controllers:\n'
lspci -k 2>/dev/null \
  | grep -EA3 'VGA|3D|Display|Audio|Network controller|Ethernet controller' \
  || true

section "AMD / VULKAN"
if have vulkaninfo; then
  vulkaninfo --summary 2>/dev/null \
    | grep -E '^(VULKAN|Devices:|GPU[0-9]|deviceName|deviceType|driverName|driverInfo|apiVersion)' \
    || true
else
  echo "vulkaninfo not installed"
fi

section "AUDIO"
if have wpctl; then
  wpctl status 2>/dev/null || true
else
  echo "wpctl not installed"
fi

section "POWER"
if have powerprofilesctl; then
  powerprofilesctl list 2>/dev/null || true
else
  echo "powerprofilesctl not installed"
fi
if have upower; then
  printf '\nUPower devices:\n'
  upower -e 2>/dev/null \
    | sed -E 's#/org/freedesktop/UPower/devices/battery_[^/]+#/org/freedesktop/UPower/devices/battery_[redacted]#' \
    || true
fi

section "NIRI / NOCTALIA"
if have niri; then
  run niri --version
  printf '\nOutputs (serial-like lines redacted):\n'
  niri msg outputs 2>/dev/null \
    | sed -E '/[Ss]erial/d; s/(serial[^:]*:).*/\1 [redacted]/I' \
    || true
else
  echo "niri not installed"
fi

if have noctalia; then
  run noctalia --version
else
  echo "noctalia CLI/version command not available"
fi

section "DISPLAY MANAGER / GREETER"
for unit in greetd.service sddm.service gdm.service lightdm.service; do
  printf '%-24s enabled=%s\n' "$unit" "$(systemctl is-enabled "$unit" 2>/dev/null || echo n/a)"
done

if [[ -f /etc/greetd/config.toml ]]; then
  printf '\n/etc/greetd/config.toml (user value redacted):\n'
  sed -E 's/^([[:space:]]*user[[:space:]]*=[[:space:]]*).*/\1"[redacted]"/' \
    /etc/greetd/config.toml 2>/dev/null || true
fi

if [[ -f /etc/pam.d/greetd ]]; then
  printf '\n/etc/pam.d/greetd:\n'
  cat /etc/pam.d/greetd 2>/dev/null || true
fi

section "LOCALE / KEYBOARD"
localectl status 2>/dev/null \
  | grep -E 'System Locale|VC Keymap|X11 Layout|X11 Model|X11 Variant|X11 Options' \
  || true

section "CONFIG FILE INVENTORY"
safe_file_inventory \
  "$HOME/.config/niri" \
  "$HOME/.config/noctalia" \
  "$HOME/.config/fish" \
  "$HOME/.config/kitty" \
  "$HOME/.config/wireplumber" \
  "$HOME/.config/pipewire"

section "CACHYOS SETTINGS / TUNING PRESENCE"
for path in \
  /etc/sysctl.d/99-cachyos-settings.conf \
  /etc/systemd/zram-generator.conf \
  /etc/ananicy.d \
  /etc/NetworkManager/conf.d \
  /etc/udev/rules.d
do
  if [[ -e "$path" ]]; then
    echo "present: $path"
  else
    echo "absent:  $path"
  fi
done

section "SNAPSHOT TOOLS"
if have snapper; then
  snapper list-configs 2>/dev/null || true
else
  echo "snapper not installed"
fi

section "QUICK HEALTH CHECK"
printf 'Failed system units:\n'
systemctl --failed --no-pager --no-legend 2>/dev/null || true
printf '\nFailed user units:\n'
systemctl --user --failed --no-pager --no-legend 2>/dev/null || true

section "END"
echo "Review the output before sharing."
