# Kanata Setup on macOS with nix-darwin

This guide covers the **one-time manual setup** required before activating your nix-darwin configuration that includes Kanata.

---

## Prerequisites (One-Time Setup)

### 1. Install Karabiner Virtual HID Driver

Kanata requires this driver to create a virtual keyboard. It cannot be installed via nix due to macOS security restrictions.

```bash
# Download the driver (v6.2.0 required for Kanata v1.8+)
curl -L -o ~/Downloads/Karabiner-DriverKit-VirtualHIDDevice-6.2.0.pkg \
  "https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/releases/download/v6.2.0/Karabiner-DriverKit-VirtualHIDDevice-6.2.0.pkg"

# Run the installer
open ~/Downloads/Karabiner-DriverKit-VirtualHIDDevice-6.2.0.pkg
```

Follow the installer prompts. When asked, grant system extension permissions in System Settings.

### 2. Activate the Driver

```bash
sudo /Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager activate
```

### 3. Grant Input Monitoring Permission to Kanata

1. Open **System Settings → Privacy & Security → Input Monitoring**
2. Click **+** to add an application
3. Press `Cmd + Shift + G` and enter:
   ```
   /run/current-system/sw/bin/kanata
   ```
4. Click **Add** and ensure the toggle is **enabled**

> **Note:** If the path doesn't work, first run `darwin-rebuild switch`, then find the path with `which kanata` and add that instead.

### 4. Check Service Status

```bash
# List all nix-darwin services
sudo launchctl list | grep org.nixos

# Check specific services
sudo launchctl list | grep karabiner
sudo launchctl list | grep kanata
```

---

## Troubleshooting

### Restart Services

```bash
# Restart Karabiner daemon
sudo launchctl stop org.nixos.karabiner-vhid
sudo launchctl start org.nixos.karabiner-vhid

# Restart Kanata (e.g., after config change)
sudo launchctl stop org.nixos.kanata
sudo launchctl start org.nixos.kanata
```

### View Logs

```bash
cat /tmp/kanata.log      # stdout
cat /tmp/kanata.err      # stderr (errors here)
```

### Verify config

```bash
# Verify file exists
ls -la ~/.config/kanata/kanata.kbd

# Test config syntax
kanata --cfg ~/.config/kanata/kanata.kbd --check
```

### Test Kanata Manually

If services aren't working, test manually to isolate the issue:

```bash
# Start Karabiner daemon in background
sudo '/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon' &

# Run Kanata in foreground (see all output)
sudo kanata --cfg ~/.config/kanata/kanata.kbd

# Exit Kanata: press Ctrl + Space + Escape
```
