> **HISTORICAL EVIDENCE (2026-08-16).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# Phase 8 Proxmox 192.168.222.222 Access Validation

Date: 2026-08-15
Status: **BLOCKED - API 401 + SSH denied (same as main PVE .187)**

## Checks

| Check | Result |
|---|---|
| API 8006 reachable | PASS |
| API auth (stored creds) | FAIL - 401 |
| SSH 22 reachable | PASS |
| SSH key auth | FAIL - Permission denied |

## Unblock paths (same as pve-api-repair.md)

1. Refresh PVE_PASSWORD for .222 in creds.env.
2. API token (PVEAuditor).
3. SSH key authorization.

## No destructive actions performed

Read-only probes only.
