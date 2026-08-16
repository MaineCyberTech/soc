# Phase 11 Change Control Runbook

Date: 2026-08-16
Purpose: track all production/lab changes during Phase 11 (repo hardening, doc normalization).

## Rules

- All changes logged with timestamp, component, action, before/after, validation.
- No `docker compose down -v`.
- No secret printing/commits.
- Historical evidence NOT rewritten - banners/index only.
- Repo changes additive and reversible.

## Change log

| # | Timestamp | Component | Change | Before | After | Validation |
|---|---|---|---|---|---|---|
| 1 | 2026-08-16 01:10 | PVE .222 thin pool | Removed 6 unused disks (vm-201-disk-8, vm-202/203/204/205-disk-0 + stale ref vm-201-disk-2) | pool 91.64% | pool 87.84% | all 5 VMs running; 0 unused refs remain; CHECK LATER: monitor stability |

## Verification procedure

1. Apply change (additive where possible).
2. Validate (scripts run, docs scan clean).
3. Update this log.

## No secrets

No secret values printed.
