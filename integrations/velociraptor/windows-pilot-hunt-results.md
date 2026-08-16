# Windows Pilot Hunt Results (Phase 8)

Date: 2026-08-15
Status: BLOCKED (no Windows client)

## When Windows client enrolled

1. Use client-config-port-8002.md pattern (server_urls VelociraptorServer:8002, CA+nonce from server).
2. velociraptor-v0.77.2-windows-amd64.exe service install.
3. GUI check-in (https://127.0.0.1:8889) -> Clients.
4. Safe hunt (Generic.Client.Info) -> export -> IRIS evidence.

## Server side ready

- 8002 listening; 3 Linux clients enrolled (path proven).
