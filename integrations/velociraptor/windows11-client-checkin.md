# Windows 11 Velociraptor Client Check-in

## Status

- SERVER READY: frontend on 8002 (validated with Linux test client C.ef79f1598cca19a9).
- Windows client: PENDING VM (PVE blocked).

## Windows client install

1. Copy client.config.yaml (port-8002 pattern: server_urls VelociraptorServer:8002,
   CA + nonce from server config, writeback per-host).
2. `velociraptor-v0.77.2-windows-amd64.exe service install --config client.config.yaml`
3. Add VelociraptorServer DNS entry (or use cert-matching hostname).
4. Verify GUI (https://127.0.0.1:8889) -> Clients -> new Windows client.

## Rollback

- `velociraptor-v0.77.2-windows-amd64.exe service remove`
