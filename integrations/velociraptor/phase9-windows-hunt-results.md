# Phase 9 Velociraptor Windows Hunt Results

Date: 2026-08-15
Client: C.d0d09f675bd30e12 (MCT-WIN11PILOT / 192.168.222.244)

## Hunt summary

- Artifact: Generic.Client.Info (safe, non-invasive)
- Flow: F.DA0DKGEQGT4GS, state FINISHED
- Collected: 26 rows across Generic.Client.Info/Users, /DetailedInfo, /BasicInformation, /WindowsInfo

## Evidence table (client-safe)

| Field | Value |
|---|---|
| Hostname | MCT-WIN11PILOT |
| OS / Arch | Microsoft Windows 11 Pro / amd64 |
| IP / MAC | 192.168.222.244 / BC:24:11:94:42:D7 |
| Gateway / DNS | 192.168.222.1 / mainecybertech.com suffix |
| Domain role | Standalone Workstation (WORKGROUP) |
| Memory | 8,519,065,600 bytes (~8.5GB) |
| Local users found | SYSTEM, LOCAL SERVICE, NETWORK SERVICE, (mctadmin) |

## Verification method

- `velociraptor --api_config phase9-api.yaml query "SELECT * FROM flows(client_id=...)"` -> FINISHED
- `query "SELECT * FROM flow_results(client_id=..., flow_id='F.DA0DKGEQGT4GS', artifact='Generic.Client.Info/BasicInformation')"` -> rows returned
- Server journal: client posts every ~60s from 192.168.222.244

## No secrets

No secret values printed.
