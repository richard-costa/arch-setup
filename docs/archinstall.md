# Archinstall choices

Use Archinstall only for the minimal base system.

Recommended choices:

- Profile: **Minimal**
- Kernel: **linux-zen**
- Networking: **NetworkManager**
- Audio: **PipeWire**
- Filesystem: **Btrfs**
- Default Btrfs subvolumes: **yes**
- Encryption: **no**
- Desktop profile: **none**
- Multilib: **enabled**

After the first boot:

```bash
git clone https://github.com/richard-costa/arch-workstation.git
cd arch-workstation
bash install.sh
```

Optional tools:

```bash
bash install/extras.sh
```

Then return to the root README for the short greeter and Noctalia setup steps.
