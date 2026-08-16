# Proxmox Test Lab Host - 192.168.222.222

## Role

Dedicated TEST environment: Windows Sysmon pilot, canary VM, DR scratch,
Linux endpoint validation, Greenbone lab scanning.

## Access (verified 2026-08-15)

- API 8006: WORKING via API token (root@pam!prox, stored as PVE222_API_TOKEN in creds.env, 0600)
- PVE version: 9.2.10
- Node: testnuc (online)
- SSH 22: OPEN (key still pending)
- Permission-limited: inventory OK; VM create/resize requires privilege bump
  (see phase8-proxmox222-access-working.md)

## Healthcheck

```bash
/opt/mct-security-stack/ops/scripts/pve222-api-healthcheck.sh
```

## VM IDs reserved

201 mct-win11-pilot01, 202 mct-canary01, 203 mct-dr-scratch01,
204 mct-linux-client01, 205 mct-vuln-target01.

## Safety

- Test workloads ONLY; no production data volumes here.
