# Phase 9 Velociraptor Windows Hunt - VALIDATED

Date: 2026-08-15
Client: C.d0d09f675bd30e12 (MCT-WIN11PILOT, 192.168.222.244)

## Result: SAFE HUNT SUCCESS

| Item | Value |
|---|---|
| Velociraptor server | frontend 0.0.0.0:8002 (systemd velociraptor.service) |
| Windows client | v0.77.2, service "Velociraptor" RUNNING (installed via `service install --config`) |
| Enrollment | CONFIRMED (server log "Please Enrol" -> posts; ClientInfo snapshot 5 items) |
| Hunt | Generic.Client.Info (non-invasive) |
| Flow | F.DA0DKGEQGT4GS - **FINISHED**, 26 rows, 4 artifacts |
| Results | BasicInformation, WindowsInfo, DetailedInfo, Users |

## Collected evidence (safe subset)

- Hostname: MCT-WIN11PILOT, OS: Microsoft Windows 11 Pro (amd64)
- Network: 192.168.222.244/24, MAC BC:24:11:94:42:D7, gw 192.168.222.1, WORKGROUP
- Memory: 8.5GB
- Users: SYSTEM, LOCAL SERVICE, NETWORK SERVICE (+ mctadmin)

## Fixes applied during setup

1. **UFW blocked 8002** (frontend) from the lab network - added
   `ufw allow from 192.168.222.0/24 to any port 8002 proto tcp`.
2. **Client service path**: velociraptor `service install` always installs to
   Program Files; the config must be passed via `--config` at install time
   (embeds it). Repacked exe (config repack) did NOT work; the explicit
   `--config` install worked.
3. **API access**: registered `phase9-hunt` API user (role administrator) via
   `velociraptor user add --role=administrator phase9-hunt <pw>` + generated
   api_client config; server restart required to load the user.
4. Client config: `server_urls: https://192.168.222.149:8002/`, CA + nonce from
   server config, writeback_windows C:\ProgramData\Velociraptor.writeback.yaml.

## IRIS evidence workflow

- Hunt results (flow F.DA0DKGEQGT4GS) are the evidence source.
- On incident: export flow via `velociraptor ... create_flow_download` or GUI,
  attach to IRIS case per phase9-windows-evidence-to-iris.md.

## Status

- Windows Velociraptor hunt: **VALIDATED**
- Windows pilot now has: Wazuh agent 012 + Sysmon + Velociraptor client

## No secrets

No secret values printed.
