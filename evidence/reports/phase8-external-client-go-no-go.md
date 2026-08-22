> **HISTORICAL EVIDENCE (2026-08-16).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# Phase 8 External Client Go/No-Go

Date: 2026-08-15
Decision: **GO (conditional) - unchanged from Phase 7, now with stronger evidence**

## Review

| Area | Phase 8 status | Gate |
|---|---|---|
| Proxmox test lab | reachable; VMs blocked (access) | NOT required for Linux-only pilot |
| Endpoint pilots | Linux PASS (native); Windows/macOS blocked | Linux-only scope OK |
| Backup scheduled proof | **PROVEN** (real cron runs 12/13/14) | PASS |
| Greenbone scan | blocked (no target) | condition: schedule + lab target before client scan |
| Canary | local canary validated; tokens decision made | optional add-on |
| Scorecard/package | COMPLETE (pilot package + sample) | PASS |
| Credential rotation | deferred (internal) | not client-facing |

## GO conditions (all must hold)

- [ ] First client scope = Linux endpoints only
- [ ] VM101 RAM increased (16+ GiB) - monitoring host stability (disk 92% is also flagged)
- [ ] Scan authorization signed
- [ ] Greenbone schedule + lab scan completed (proves scan workflow)
- [ ] Escalation contacts verified (P3 test)
- [ ] level.io vars + group configured

## NO-GO for

- Windows-only or Sysmon-requiring clients (no pilot device yet)
- Clients needing canary/deception add-on (token deployment pending)

## Verdict

GO (conditional, Linux-only). Evidence is materially stronger than Phase 7
(backup scheduled proof achieved). Disk 92% is a NEW risk requiring operator
capacity action before client onboarding.
