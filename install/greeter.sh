#!/usr/bin/env bash

# Configure Noctalia Greeter as greetd's graphical login screen.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if ! command -v noctalia-greeter-session >/dev/null 2>&1; then
  echo "error: noctalia-greeter is not installed. Run install/aur.sh first." >&2
  exit 1
fi

if ! id -u greeter >/dev/null 2>&1; then
  sudo useradd -r -s /usr/bin/nologin -d /var/lib/noctalia-greeter greeter
fi

if ! sudo cmp -s "$ROOT/system/greetd/config.toml" /etc/greetd/config.toml 2>/dev/null; then
  sudo cp -a /etc/greetd/config.toml /etc/greetd/config.toml.bak 2>/dev/null || true
  sudo install -Dm644 "$ROOT/system/greetd/config.toml" /etc/greetd/config.toml
fi

sudo systemctl enable greetd.service

echo "Noctalia Greeter configured and enabled for the next boot."