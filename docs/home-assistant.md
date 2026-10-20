# Home Assistant on ms-a2

The `ms-a2` configuration runs the official Home Assistant Container with Docker
and starts it automatically at boot. Apply the local configuration on `ms-a2`:

```bash
sudo nixos-rebuild switch --flake .#ms-a2
```

Open <http://192.168.10.3:8123> from the LAN and complete onboarding to create
the administrator account. The firewall allows TCP port 8123 on `enp3s0`.
The container uses host networking for LAN discovery and the `Asia/Tokyo` timezone.
The first start requires access to `ghcr.io` to download the image.

Configuration, credentials, and the database persist in `/var/lib/home-assistant`.
Back up this directory while the service is stopped and before upgrading:

```bash
sudo install -d -m 0700 /var/backups
sudo systemctl stop docker-home-assistant
sudo tar -C /var/lib -czf /var/backups/home-assistant-$(date +%Y%m%d-%H%M%S).tar.gz home-assistant
sudo systemctl start docker-home-assistant
```

Store backups securely because they contain credentials. To inspect startup or troubleshoot:

```bash
sudo systemctl status docker-home-assistant
sudo docker logs --tail 100 home-assistant
```

The image version is pinned in [`hosts/nixos/ms-a2/default.nix`](../hosts/nixos/ms-a2/default.nix); update the tag
and rebuild to upgrade. Home Assistant Container does not include Supervisor
or apps (formerly add-ons). USB radios for protocols such as Zigbee and Z-Wave
require additional device configuration. See the
[official Container installation guide](https://www.home-assistant.io/installation/linux#install-home-assistant-container).

## Catppuccin theme

Nix downloads the pinned [Catppuccin v2.1.3 release](https://github.com/catppuccin/home-assistant/releases/tag/v2.1.3)
and mounts `catppuccin.yaml` read-only at `/config/themes/catppuccin.yaml`.
It includes Latte, Frappé, Macchiato, and Mocha with the default mauve accent.
HACS is not required. Update the URL and SHA-256 in
`hosts/nixos/ms-a2/default.nix` to upgrade the theme.

After rebuilding, enable theme loading once in
`/var/lib/home-assistant/configuration.yaml`:

```yaml
frontend:
  themes: !include_dir_merge_named themes
```

If `frontend:` already exists, add `themes:` to that section instead of creating
a duplicate key. Preserve the other configuration settings. If theme loading is
already configured with this include, no edit is needed.

Check the configuration and restart Home Assistant:

```bash
sudo docker exec home-assistant python -m homeassistant --script check_config --config /config
sudo systemctl restart docker-home-assistant
```

Open your Home Assistant profile and select a Catppuccin theme under
**Browser settings > Theme**. This selection applies to the current browser;
repeat it on other devices as needed. For later theme updates, run the
`frontend.reload_themes` action from **Developer tools > Actions** or restart
Home Assistant. See the [upstream installation instructions](https://github.com/catppuccin/home-assistant#usage).

## Bluetooth and SwitchBot CO2 meter

The host enables BlueZ and powers Bluetooth adapters on at boot. Home Assistant
accesses BlueZ through the read-only `/run/dbus` mount and receives the `NET_ADMIN`
and `NET_RAW` capabilities required for Bluetooth management. The container starts
after the host Bluetooth and D-Bus services. See the
[Bluetooth requirements](https://www.home-assistant.io/integrations/bluetooth/#requirements-for-linux-systems).

The SwitchBot CO2 meter (Meter Pro CO2) is supported by the
[SwitchBot Bluetooth integration](https://www.home-assistant.io/integrations/switchbot/).
It exposes CO2 concentration, temperature, humidity, and battery level. A SwitchBot
Hub is not required. The host needs a working Bluetooth adapter within range of
the meter; enabling the service alone does not provide Bluetooth hardware.

After applying the configuration on `ms-a2`, check the adapter:

```bash
systemctl status bluetooth
bluetoothctl list
bluetoothctl show
```

Confirm that a controller is listed and `Powered: yes` appears. If no controller
is listed, check the built-in adapter or connect a Linux-compatible USB Bluetooth
adapter. If it is blocked, inspect `rfkill list` and unblock Bluetooth as needed.

1. Power on the meter and place it near `ms-a2` for initial setup.
2. Open Home Assistant and go to **Settings > Devices & services**. Configure the
   discovered **Bluetooth** integration, or select **Add integration > Bluetooth**.
   Keep the adapter in active scanning mode for local device discovery.
3. Configure the discovered SwitchBot meter. If it does not appear, select
   **Add integration > SwitchBot Bluetooth** and follow the setup flow.
4. Open the device and confirm that its CO2, temperature, and humidity readings
   update. Use the BTLE MAC address in the SwitchBot app's device information to
   distinguish multiple meters.

If discovery fails, check Bluetooth's advertisement monitor in Home Assistant,
move the meter closer, and close any phone app connection to it. Check logs with:

```bash
sudo journalctl -u bluetooth -b --no-pager -n 100
sudo docker logs --tail 100 home-assistant
```
