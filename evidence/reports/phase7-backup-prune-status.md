> **HISTORICAL EVIDENCE (2026-08-16).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# Phase 7 Backup Prune Status

Date: 2026-08-12

## Result: PASS

- prune-phase5-backups.sh --apply (cron syntax) executed: 0 pruned (all within retention).
- Retention: IRIS 14d, MISP 14d, Greenbone 35d, Shuffle 56d.
- Explicit patterns only; secret files/phase2 configs never touched.

## Disk impact

- Current backups: IRIS 36K x2, MISP 149MB x2, Greenbone 1.8GB, Shuffle 30KB x3.
- Greenbone at 35d retention ~9GB peak - monitored with disk (82%).
