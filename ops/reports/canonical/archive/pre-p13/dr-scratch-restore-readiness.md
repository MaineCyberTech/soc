# DR Scratch Restore Readiness

Date: 2026-08-11
Status: **READY (resources sufficient except RAM headroom)**

## Resources

| Resource | Required | Available | Verdict |
|---|---|---|---|
| Disk | ~10 GB | 17 GB | OK |
| RAM | ~2-4 GB | ~1 GB free | TIGHT - defer until VM101 RAM increase |
| Snapshot source | latest SUCCESS | snap-20260811-2017 | OK |

## Blocker for execution

- RAM headroom (~1 GB free, 4.7 GB swap in use) - scratch OpenSearch with 2 GB
  heap would increase swap pressure. Recommended: execute after VM101 RAM
  increase (Phase 6.03 pending PVE action).

## Deliverables

- ops/runbooks/dr-scratch-restore-execution.md - executable steps
- ops/reports/dr-scratch-restore-results.md - results (pending)
- ops/checklists/dr-scratch-restore-checklist.md

## Validation checks defined

Snapshot restore (index count/docs/timestamps), config extract, compose parse,
IRIS/MISP/Greenbone DB restore (schema/verify), cleanup, production untouched.
