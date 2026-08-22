# Phase 24 Checklist Directory Consolidation

Date: 2026-08-22
Status: **COMPLETE**

## Change

- Moved the 4 root-level checklists into `ops/checklists/` (renamed
  `phase24-consolidated-*` to avoid collision with the pre-change naming):
  - dr-restore-test-checklist.md, dr-scratch-restore-checklist.md,
    phase4-pre-change-checklist.md, phase8-dr-restore-checklist.md.
- Removed the empty root `checklists/` dir.
- Fixed REPO-MAP (removed stale root reference; ops/checklists/ remains the canonical path).

## Canonical path

- **`ops/checklists/`** is the single canonical checklist location (now 19 files + 4
  consolidated = 23 total, incl. phase22/23/24 gates + v1-1-release).

## No secrets