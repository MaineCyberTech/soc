> **HISTORICAL EVIDENCE (2026-08-16).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# Phase 7 Operator Unblock Status

Date: 2026-08-12

| Blocker | Status | Owner | Manual bypass | Verified? |
|---|---|---|---|---|
| PVE API/SSH | OPEN | host operator | pve-api-repair.md (3 paths) | no |
| VM101 RAM | OPEN | host operator | PVE console | no |
| P1 credentials | DEFERRED | host operator | one-at-a-time rotation | framework PASS |
| Greenbone GMP/GSA | OPEN | VM103 operator | GSA UI (admin pw in .env) | gvmd healthy |
| Canarytokens | OPEN | host operator | hosted account | no |
| Windows endpoint | OPEN | host operator | existing device | no |
| macOS endpoint | OPEN | host operator | test Mac | no |
| Velociraptor GUI pw | OPEN | host operator | CLI set_password | 2 clients enrolled |

## Summary

All infrastructure blockers remain operator-owned. Everything automatable is
ready: endpoint kit, Velociraptor path, backup cron, validation frameworks.
The Linux pilot can proceed locally (docker-host as target) - all others
require operator unblock.

## Action list

1. Operator: pick one PVE unblock path (quickest: SSH key).
2. Operator: set Velociraptor GUI password (5-min task, unblocks hunt via GUI).
3. Operator: choose Canarytokens service.
4. Operator: provide Windows/macOS test endpoints.
