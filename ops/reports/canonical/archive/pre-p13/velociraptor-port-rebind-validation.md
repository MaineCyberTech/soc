# Velociraptor Port Rebind

Date: 2026-08-11
Status: **COMPLETE - frontend on 8002, client connected**

## What was done

1. Port audit: 8000 owned by Portainer (container publish), 8002 free.
2. Backed up server.config.yaml (ops/backups/velociraptor-server-config.bak-20260811).
3. Updated server config: `Frontend.bind_port: 8002`,
   `Client.server_urls: [https://localhost:8002/]`.
4. Restarted velociraptor service.
5. Verified: `GET https://127.0.0.1:8002/server.pem` -> 200.

## Client connectivity fix (root causes)

| Issue | Fix |
|---|---|
| Client config generated with wrong URL (8000) | Set server_urls to `https://VelociraptorServer:8002/` (cert SAN hostname) |
| Client CA mismatch (config generate embeds different CA) | Copy server config `Client.ca_certificate` into client config |
| Client nonce mismatch (config generate regenerates nonce) | Copy server `Client.nonce` into client config |
| VelociraptorServer hostname unresolvable | Added `127.0.0.1 VelociraptorServer` to /etc/hosts |
| Stale writeback from pre-fix enrollment (never really enrolled - connected to Portainer) | Fresh writeback; fresh enrollment |

## Result

- Client enrolled: `C.ef79f1598cca19a9` (server filestore: clients/C.ef79f1598cca19a9/)
- Check-in verified: `/reader` HTTP 200, `/control` HTTP 200
- Flow executed: F.D9TR4TO1N2RC2 (Generic.Client.Stats) collected + completed
- Evidence stored: collections/stats.json.db + requests.json.db

## Note

- The frontend certificate SAN is `VelociraptorServer` - clients must use that
  hostname (or a proper DNS name matching the cert).
- GUI admin user exists but has no password set (Phase 2 runbook step pending) -
  required for GUI/API hunt launches. Operator: `velociraptor user set_password admin`.
