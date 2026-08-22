> **HISTORICAL EVIDENCE (2026-08-16).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# Phase 8 Proxmox 192.168.222.222 Access - WORKING (full Administrator)

Date: 2026-08-15 (updated - token ACL fixed)

## Credential (name only)

- `PVE222_API_TOKEN` in creds.env (0600): `root@pam!prox=<secret>`

## Fix applied (2026-08-15)

The token had NO ACL entries (empty /access/acl) - only /version worked.
VM paths returned 401. Fixed via root API: added Administrator role on `/`
with propagate for `tokens=root@pam!prox`.

## Verified working (all 200)

- /version, /nodes, /cluster/resources
- /nodes/testnuc/qemu/201/config (was 401)
- /nodes/testnuc/qemu/201/status/current (was 401)
- /access/acl

## Note

- Proxmox ACL tokens format: `tokens` param = `user@realm!tokenid`
  (e.g. root@pam!prox) - NOT the bare token id.
- Healthcheck: pve222-api-healthcheck.sh (now fully PASS)
