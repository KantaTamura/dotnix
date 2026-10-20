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

## HACS

HACS manages community integrations, dashboard extensions, and themes in the
writable `/config` directory. Its files persist under
`/var/lib/home-assistant/custom_components/hacs` across container replacements
and NixOS rebuilds. Install and update extensions through HACS.

The pinned Home Assistant 2026.10.2 image uses HACS as a custom integration.
Follow the [official Container installation instructions](https://www.hacs.xyz/docs/use/download/download/).
After backing up the configuration and rebuilding NixOS, open a shell:

```bash
sudo docker exec -it home-assistant bash
```

Inside the container, download and run the official installer once:

```bash
cd /config
wget -O /tmp/get-hacs.sh https://get.hacs.xyz
bash /tmp/get-hacs.sh
exit
```

Skip the installer if HACS is already installed. Restart Home Assistant:

```bash
sudo systemctl restart docker-home-assistant
```

In Home Assistant, hard-refresh the browser, open **Settings > Devices &
services > Add integration**, and select **HACS**. Follow the prompts to
authorize HACS using GitHub's device-code flow. Complete this in your own browser;
do not put tokens in this repository. See the [initial configuration guide](https://www.hacs.xyz/docs/use/configuration/basic/).

HACS does not install Supervisor apps such as Matter Server; that container
remains managed by Nix. When upgrading Home Assistant to 2026.11 or later,
consult the current HACS migration instructions: upstream documents a transition
to the built-in Marketplace for those releases.

## Catppuccin theme via HACS

Catppuccin is installed and updated through HACS. Nix no longer downloads or
mounts the theme file. If migrating from the previous Nix-managed installation,
rebuild NixOS first to remove the read-only bind mount.

Enable theme loading in `/var/lib/home-assistant/configuration.yaml`:

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

The old file bind mount may leave an empty file at
`/var/lib/home-assistant/themes/catppuccin.yaml`. If that file remains, move it
outside the themes directory after rebuilding and before reloading themes:

```bash
sudo mkdir -p /var/lib/home-assistant/theme-backups
sudo mv /var/lib/home-assistant/themes/catppuccin.yaml /var/lib/home-assistant/theme-backups/catppuccin.yaml.pre-hacs
```

Skip this step if the old file does not exist. Moving it also avoids duplicate
theme definitions if a previous manual copy exists. HACS manages its own theme
files under `/config/themes/`.

In HACS, search for **Catppuccin**, select the theme repository
`catppuccin/home-assistant`, and download it. This installs Latte, Frappé,
Macchiato, and Mocha with the default mauve accent. Run `frontend.reload_themes`
from **Developer tools > Actions** after downloading.

Open your Home Assistant profile and select a Catppuccin theme under
**Browser settings > Theme**. This selection applies to the current browser;
repeat it on other devices as needed. For later theme updates, run the
`frontend.reload_themes` action from **Developer tools > Actions** or restart
Home Assistant. See the [upstream installation instructions](https://github.com/catppuccin/home-assistant#usage).

## Matter and Nature Remo Lapis

`ms-a2` also runs Matter.js Server 1.4.0 in a host-networked container.
Home Assistant connects to its WebSocket API at `ws://127.0.0.1:5580/ws`.
The API listens only on loopback; port 5580 does not need LAN access.
Matter discovery and device traffic use `enp3s0`: mDNS UDP 5353 and IPv6
link-local UDP are allowed on that interface. Matter uses dynamic UDP ports,
so opening only UDP 5540 is insufficient. IPv6 must remain enabled on the host.
See the [server network requirements](https://github.com/matter-js/matterjs-server/blob/v1.4.0/docs/os_requirements.md)
and [container instructions](https://github.com/matter-js/matterjs-server/blob/v1.4.0/docs/docker.md).
Standalone Matter containers are documented upstream but are outside Home
Assistant's officially supported Home Assistant OS installation path.

Matter credentials and pairing data persist in `/var/lib/matter-server`, owned
by UID/GID 1000 to match the image. Back up this directory as well as
`/var/lib/home-assistant`; stop both containers during backup. Losing the Matter
data requires pairing the devices again. The image tag is pinned in
`hosts/nixos/ms-a2/default.nix`.

Nature Remo Lapis bridges registered appliances into Matter over Wi-Fi;
a Thread border router or Thread USB adapter is not needed for Lapis.
Use the Nature Home app to set up Lapis, update its firmware, and register the
appliances first. Available controls depend on what Lapis exposes through
Matter, rather than every button or sensor in the Nature Home app.
See [Nature's Lapis specifications](https://nature.global/press/release/20272/).

After applying the NixOS configuration:

1. Verify that Matter Server has started:

   ```bash
   sudo systemctl status docker-matter-server
   sudo docker logs --tail 100 matter-server
   ip -6 addr show dev enp3s0 scope link
   ```

   The interface should have a `fe80::` link-local address.
2. In Home Assistant, open **Settings > Devices & services > Add integration >
   Matter**. If offered an option to install the Matter Server app, deselect it
   and connect to the existing server at `ws://127.0.0.1:5580/ws`.
3. Connect the phone to the same LAN as Lapis and `ms-a2`. Allow Bluetooth and
   local-network permissions for the Home Assistant Companion app. Avoid guest
   Wi-Fi, client isolation, and multicast filtering during pairing.
4. For a new Matter pairing, enable Matter linking in the Nature Home app and
   obtain the setup code. In the Home Assistant Companion app, select
   **Settings > Devices & services > Add device > Add Matter device**, choose
   the new-device flow, and scan or enter the code. Complete the phone prompts.
   Commissioning uses the phone, so Matter Server does not need direct access
   to the host Bluetooth adapter.
5. If Lapis is already paired with Apple Home, Google Home, or another Matter
   controller, use that controller's sharing/pairing mode to generate a new
   code. In the Companion app, choose the already-in-use flow and enter that
   code. Keep the existing pairing; do not factory-reset Lapis.
6. Open the resulting Matter device in Home Assistant, check the bridged
   appliances, and test a light or another appliance's power control. Add the
   available entities to a dashboard or automation as needed.

See the [Home Assistant Matter pairing instructions](https://www.home-assistant.io/integrations/matter/)
for Android/iOS requirements and the sharing flow. If pairing fails, check
Matter Server logs and the LAN's IPv6/multicast connectivity before retrying.
The firewall exception here covers link-local devices on `enp3s0`; devices
using other routed IPv6 prefixes or separate VLANs need additional networking
and firewall configuration.

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
