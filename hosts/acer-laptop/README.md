# Acer laptop

Hardware notes that may matter for troubleshooting:

- AMD Ryzen 7 3700U
- AMD Vega integrated GPU
- AMD Topaz XT discrete GPU
- both GPUs use `amdgpu`
- Intel AC 3168 Wi-Fi
- Realtek Ethernet
- internal display: `eDP-1`
- external LG ultrawide usually appears as `HDMI-A-1`

Niri currently handles display modes and positioning automatically, so there is
no machine-specific display config in this repository.

Keep future hardware-specific fixes here only when they are actually needed
(for example, an audio workaround).
