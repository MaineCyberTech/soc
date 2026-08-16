# Velociraptor Client Rollout — Linux

Purpose: enroll Linux hosts (Debian/Ubuntu, Wazuh hosts, PVE) into Velociraptor.

## Preconditions

- Server running; client config exported from GUI (Configuration -> Client Config).
- Operator approval for each host class (production rollout in waves).

## Steps

1. Download the Linux client binary (deb or binary matching server version) from GUI -> `Server.Utils.Configure.Client` or the release assets.
2. Install config:

```bash
sudo install -m 0600 client.config.yaml /etc/velociraptor/client.config.yaml
```

3. Install the binary (example, Debian):

```bash
sudo dpkg -i velociraptor_<REDACTED_VERSION>_amd64.deb   # if package
# or manual: install binary to /usr/local/bin/velociraptor
```

4. Start and enable:

```bash
sudo systemctl enable --now velociraptor-client
sudo systemctl status velociraptor-client
```

## Verification

- GUI: client appears online.
- Run `Generic.Client.Info` and `Linux.System.Users` test hunts.
- Optional syslog forwarding: client sends its own activity to Wazuh via existing agent.

## Host classes and waves

- Wave 1 (pilot): one internal Linux host + one Wazuh manager (non-production action).
- Wave 2: remaining internal Linux hosts.
- Wave 3: remote hosts via Cloudflare Tunnel TCP route (frontend must be reachable; use `Client.use_self_signed_ssl` or tunnel).

## Acceptance

- Client online, test hunt completes, no agent group changes.
