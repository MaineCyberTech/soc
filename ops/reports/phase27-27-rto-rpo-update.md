# Phase 27 RTO and RPO Evidence Update

Date: 2026-08-24
Status: **EVIDENCE-BACKED OBSERVATIONS** (not a full-cluster restore claim).

## Combined drill evidence

| Drill | Scope | Result | Timing |
|---|---|---|---|
| Config-bundle (P25) | DR S3 config bundle download+checksum+extract | PASS (sha match 4c00952d...) | download 0.2s |
| Single-index (P26) | 1 states index restore (p26-restore-*) | PASS (114/114) | seconds |
| Multi-index (P27) | 3 states indices (p27-restore-*) | PASS (114/447/2248 snapshot-consistent; cross-index query 2809 hits) | seconds |

## RTO/RPO observations

- **RPO**: <= 24h (config bundle daily 04:00; snapshots 5-hourly with 7d window).
- **RTO (observed, per-scope)**: config bundle < 1 min; index-level restore seconds (per
  small index); full-cluster restore NOT exercised (requires scheduled full drill - Phase 28).

## Boundary

- These drills validate components only; full-cluster RTO remains unclaimed until a complete
  scratch-cluster restore drill.

## No secrets