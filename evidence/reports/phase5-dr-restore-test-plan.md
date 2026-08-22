> **HISTORICAL EVIDENCE (2026-08-16).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# Phase 5 DR Restore Test Plan

Date: 2026-08-11
Status: **PLAN COMPLETE - execution requires operator approval (scratch only)**

## Scope

- OpenSearch snapshot restore (scratch)
- Wazuh config restore validation
- Phase stack config restore validation
- IRIS/MISP/Greenbone DB restore validation (scratch)

## Deliverables

- ops/runbooks/dr-scratch-restore-test.md - full architecture + restore order + validation checks + cleanup
- ops/checklists/dr-restore-test-checklist.md

## Acceptance

- DR test plan exists: YES
- No production data restored destructively: CONFIRMED (copies only)
- Validation criteria clear: YES (6 checks with pass criteria)

## Why scratch

- Validates restore paths before any real DR event.
- Proves snapshot/dump integrity (gzip verified earlier; restore validates content).
- No production impact by design.

## Operator action

1. Approve scratch test.
2. Allocate 10 GiB disk + 4 GiB RAM for scratch containers.
3. Execute runbook steps; record results in this file.
