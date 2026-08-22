> **HISTORICAL EVIDENCE (2026-08-16).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# Phase 6 P1 Credential Rotation Results

Date: 2026-08-11
Status: **ALL P1 DEFERRED - no new protected values supplied**

| Credential | Priority | Status | Validation | Blocker |
|---|---|---|---|---|
| DO Spaces keys | P1 | DEFERRED | PASS (S3 list works) | No new values (creds.env mtime 08-09 unchanged) |
| WAZUH_ADMIN_PASSWORD | P1 | DEFERRED | PASS (indexer green) | No new values |
| Cloudflare tunnel token | P1 | DEFERRED | PASS (tunnel running) | No new values (.env.cloudflare mtime 08-07) |
| IRIS/MISP/Shuffle/VM103 | P2/P3 | READY | PASS (validation suite) | Awaiting rotation window |

## Framework ready

- ops/scripts/credential-rotation-validation.sh (6 checks PASS)
- ops/scripts/phase5-credential-postcheck.sh (extended checks)
- ops/runbooks/phase5-p1-credential-rotation.md (one-at-a-time procedure)
- ops/checklists/phase6-credential-rotation-verification.md

## Next action

Operator generates new values into protected 0600 files; execute one rotation
per step with validation between (postcheck) before revoking old values.
