# mct-canary01 Build Validation

Date: 2026-08-11
Status: **BLOCKED - PVE API 401 + no SSH key (unchanged)**

## Blocker

- PVE API: 401 (stale creds in creds.env)
- PVE SSH: Permission denied (no authorized key)
- Unblock: pve-api-repair.md (refresh password / API token / SSH key)

## Ready artifacts (unchanged, verified)

- ops/runbooks/mct-canary01-final-build.md - qm create 110 commands
- integrations/opencanary/mct-canary01-final-config.md - OpenCanary config
- ops/reports/mct-canary01-validation.md - validation path

## When unblocked (manual bypass)

1. PVE console or SSH: qm create 110 (per manual-vm-provisioning-bypass.md).
2. Install OpenCanary (mct-canary01-final-config.md).
3. Syslog to 192.168.222.149:514 (allowed-ips covers 192.168.222.0/24).
4. Validate: soc-smoke-test.sh --opencanary + rule 121012 + IRIS.

## No action taken

- No destructive provisioning; read-only probes only.
