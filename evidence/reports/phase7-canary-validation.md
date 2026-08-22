> **HISTORICAL EVIDENCE (2026-08-16).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# Phase 7 Canary Validation

Date: 2026-08-12
Status: **LOCAL CANARY VALIDATED; Canarytokens/mct-canary01 BLOCKED**

## Working deception control

- Local OpenCanary (opencanary-mct-01) validated: soc-smoke-test.sh --opencanary
  -> rule 121012 fired (level 12, Class A) -> IRIS path ready.

## Blocked (documented)

| Control | Blocker |
|---|---|
| Canarytokens (T1 fake-backup-credentials.txt etc.) | No canarytokens service (hosted account / self-hosted VM) |
| mct-canary01 VM | PVE API 401 (no provisioning) |

## Acceptance

- One deception path active and validated: YES (local canary, D1 drill)
- No real secrets embedded: CONFIRMED

## Next action

Operator: provision canarytokens service (hosted account fastest) OR unblock PVE
for mct-canary01. Token/webhook wiring documented (canarytokens-phase6-deployed.md).
