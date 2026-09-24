#!/usr/bin/env bash

# Enable the background services expected by this workstation.
# Optional services are only touched when their packages are installed.
set -euo pipefail

# Core connectivity.
sudo systemctl enable --now NetworkManager.service
sudo systemctl enable --now bluetooth.service

# Periodically issue TRIM/discard operations for SSD/NVMe storage.
sudo systemctl enable --now fstrim.timer

# If UFW is installed, start with a simple workstation firewall:
# block unsolicited incoming connections and allow outgoing traffic.
if systemctl list-unit-files ufw.service >/dev/null 2>&1; then
  sudo ufw default deny incoming
  sudo ufw default allow outgoing
  sudo ufw --force enable
fi

# Noctalia Greeter uses greetd. We enable it for the next boot rather than
# starting it immediately, which could disrupt the current graphical session.
if systemctl list-unit-files greetd.service >/dev/null 2>&1; then
  sudo systemctl enable greetd.service
fi

# pacman-contrib: periodically removes old cached package versions.
if systemctl list-unit-files paccache.timer >/dev/null 2>&1; then
  sudo systemctl enable --now paccache.timer
fi

# pkgfile: periodically updates the database used to find which package
# provides a missing command/file.
if systemctl list-unit-files pkgfile-update.timer >/dev/null 2>&1; then
  sudo systemctl enable --now pkgfile-update.timer
fi

# Let systemd keep the system clock synchronized through NTP.
sudo timedatectl set-ntp true
