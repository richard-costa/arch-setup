# Noctalia Greeter

Install it through the AUR manifest:

```bash
bash install/aur.sh
```

`noctalia-greeter` uses **greetd** and the session wrapper:

```text
/usr/bin/noctalia-greeter-session
```

After installation, check:

```bash
cat /etc/greetd/config.toml
```

The important part is:

```toml
[default_session]
command = "/usr/bin/noctalia-greeter-session"
user = "greeter"
```

If the package did not configure greetd automatically, edit that file manually.

Then enable greetd:

```bash
sudo systemctl enable greetd.service
```

Do not start it from inside the current graphical session; reboot instead.

Noctalia handles greeter appearance sync through its own settings.
