# Phase 22 v1.1.0 Source-of-Truth Cleanup

Date: 2026-08-22

## Stale wording found + fixed (current-state docs only; no historical evidence modified)

| File | Before | After |
|---|---|---|
| RELEASE-NOTES.md | `## v1.1.0 (planned - not yet released; approval-gated)` + "Push pending" | `## v1.1.0 (2026-08-19) - Published` with release record/checklist pointers |
| README.md | "FULLY DEPLOYED and verified 2026-08-10" | "FULLY DEPLOYED and verified. Current release: v1.1.0 (2026-08-19)" |

## Consistency checks

| Item | Status |
|---|---|
| v1.1.0 tag | pushed, points at 85cba85 (P21.6) |
| v1.1.0 release object | published 08-19 07:27 UTC, asset `mct-security-stack-release-20260819-072400.tar.gz` (uploaded, 3,746,989 bytes) |
| Bundle sha256 record | `25d35eb6c4df2e310ecf95f38849b14fa188f60a621a37af7b1b82371c089625` (release-manifest + release record) |
| phase21 release record | COMPLETE (updated 08-19) |
| v1-1-release-checklist | marks release complete; no pending-approval wording remains |
| README / RELEASE-NOTES / ARCHITECTURE / REPO-MAP | agree on v1.1.0 current (no stale v1.0.0-current or v1.1.0-pending wording) |
| Historical evidence | NOT modified (per rule: historical evidence only via addendum) |

## Notes

- ARCHITECTURE.md / REPO-MAP.md had no release-version references to fix.
- `phase21-v1-1-release-record.md` updated to COMPLETE in P21.8 (kept as-is; addendum pattern respected).

## No secrets