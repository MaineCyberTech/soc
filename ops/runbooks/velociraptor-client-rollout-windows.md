# Velociraptor Client Rollout — Windows

Purpose: enroll Windows 11 endpoints into Velociraptor for DFIR collection.

## Preconditions

- Server running, `client.config.yaml` exported (server GUI: Configuration -> Client Config, or `velociraptor config show_client`).
- Deployment method chosen: per-endpoint installer (MSI) or MSI via GPO.
- Approved by operator — no production rollout without approval.

## Steps

1. Download the Windows client: GUI -> Server Artifacts -> `Server.Utils.Configure.Client` or fetch the prebuilt binary matching server version.
2. Generate client config: GUI -> Configuration -> Client Config -> copy to `client.config.yaml` (contains `Client.server_urls` pointing at the Velociraptor frontend).
3. Build a self-contained MSI:

```powershell
velociraptor config repack --msi client.config.yaml velociraptor-<REDACTED_VERSION>.msi
```

4. Install silently:

```powershell
msiexec /i velociraptor-<REDACTED_VERSION>.msi /qn /l*v c:\windows\temp\velociraptor-install.log
```

5. Verify enrollment in server GUI (Clients -> Recent).

## GPO mass deployment (optional)

- Drop MSI in a network share; GPO computer software installation assignment.
- Scope to a pilot group first; enroll in waves during approved maintenance windows.

## Post-install

- Confirm service `Velociraptor` running: `sc query Velociraptor`.
- Confirm logs to Wazuh (agent group `windows`): Sysmon collection per `integrations/sysmon/` — Velociraptor telemetry is complementary, not a log shipper.

## Acceptance

- Client appears online in GUI.
- A test hunt (`Generic.Client.Info`) completes on the client.
- No changes to existing Wazuh agent group config.
