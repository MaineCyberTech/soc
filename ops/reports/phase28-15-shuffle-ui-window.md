# Phase 28 Shuffle UI Edit Window

Date: 2026-08-24
Status: **WINDOW OPEN BUT APPROVAL PENDING** (C6).

## Backup / rollback (ready)

- Workflow exported + versioned: `integrations/shuffle/backups/wazuh-high-severity-to-iris-phase27-export.json` (redacted).
- Rollback: update API via that export verified 200 (P27) - can restore previous revision.
- Shuffle workflow revisions/versioning documented (research notes).

## Requirements before any UI edit

- Redacted backup (done); operator confirms UI window (approval); evidence plan (this doc);
  guardrail remains active during edit (independent backstop).

## Approval

- Operator must explicitly approve the UI edit window before nodes are added.

## No secrets