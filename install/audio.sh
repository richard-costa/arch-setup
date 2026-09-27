#!/usr/bin/env bash

# Reload PipeWire after the RNNoise filter is deployed and persist the generated
# "Clean Microphone" source as the default input. PipeWire node IDs are runtime
# values, so discover rnnoise_source by name instead of hardcoding an ID.
set -euo pipefail

systemctl --user restart pipewire pipewire-pulse
sleep 2
systemctl --user restart wireplumber

for _ in {1..20}; do
    status="$(wpctl status -n 2>/dev/null || true)"
    clean_mic_id="$(
        sed -nE 's/^[^0-9]*([0-9]+)\. rnnoise_source[[:space:]]+\[Audio\/Source\].*/\1/p' <<<"$status" |
            head -n1
    )"

    if [[ -n "$clean_mic_id" ]]; then
        wpctl set-default "$clean_mic_id"
        echo "Clean Microphone set as default (node $clean_mic_id)."
        exit 0
    fi

    sleep 0.5
done

echo "error: rnnoise_source was not created" >&2
exit 1
