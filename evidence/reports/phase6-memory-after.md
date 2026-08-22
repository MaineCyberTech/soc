> **HISTORICAL EVIDENCE (2026-08-16).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# Phase 6 Memory After

Date: 2026-08-11
Status: **NO CHANGE APPLIED - RAM increase pending operator action on PVE**

## State

- RAM still 9.3 GiB; swap 4.7 GiB used.
- PVE API blocked (stale creds) prevents automated `qm set 101 --memory` - or
  operator may change via PVE console directly.

## When operator changes RAM

1. PVE console/API: `qm set 101 --memory 16384` (16 GiB) - reboot or hotplug.
2. Run: `/opt/mct-security-stack/ops/scripts/resource-post-change-validation.sh`
3. Expected PASS: RAM >= 16 GiB, swap < 1 GiB, healthcheck OK.
4. Then run full-stack-healthcheck.sh + healthcheck-selftest.sh.

## Alternative (if RAM cannot be added)

- Workload move decision: Shuffle -> VM103 (workload-move-decision.md).
- No moves performed without approval.
