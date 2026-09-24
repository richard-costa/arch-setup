#!/usr/bin/env bash
set -euo pipefail

sudo systemctl enable --now NetworkManager.service
sudo systemctl enable --now bluetooth.service
sudo systemctl enable --now fstrim.timer

if systemctl list-unit-files ufw.service >/dev/null 2>&1; then
  sudo ufw default deny incoming
  sudo ufw default allow outgoing
  sudo ufw --force enable
fi

if systemctl list-unit-files greetd.service >/dev/null 2>&1; then
  sudo systemctl enable greetd.service
fi

if systemctl list-unit-files paccache.timer >/dev/null 2>&1; then
  sudo systemctl enable --now paccache.timer
fi

if systemctl list-unit-files pkgfile-update.timer >/dev/null 2>&1; then
  sudo systemctl enable --now pkgfile-update.timer
fi

sudo timedatectl set-ntp true
