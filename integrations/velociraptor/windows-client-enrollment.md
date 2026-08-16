# Windows Velociraptor Client Enrollment

## Status

BLOCKED - two blockers:
1. No Windows test endpoint (PVE API 401 prevents VM provisioning).
2. Velociraptor frontend port conflict (Portainer owns 8000) - client-server path not functional.

## When unblocked

1. Fix frontend port (test-client-enrollment.md) - server side.
2. Build Windows 11 VM; install velociraptor client MSI:
   `velociraptor-v0.77.2-windows-amd64.exe service install --config client.config.yaml`
3. Verify: GUI -> Clients -> new Windows client online.
4. Run Generic.Client.Info hunt (non-invasive) -> export zip -> IRIS evidence.

## Rollback

- `velociraptor-v0.77.2-windows-amd64.exe service remove`
- Delete client from server (GUI -> Clients -> remove) if needed.
