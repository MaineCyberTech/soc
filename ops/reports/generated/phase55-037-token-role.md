# Phase 55: IRIS Token Role

**Prompt:** 037-token-role
**Generated (UTC):** 2026-08-28T00:35:00Z
**Operator (EDT):** 2026-08-27T20:35:00-0400
**Verdict:** PARTIAL

## Summary
Assess whether the IRIS token carried by the secret is admin versus least-privilege capability.

## Evidence
- **EV-037-1 (PARTIAL):** The token lives in `data/shuffle/files/iris-shuffle.env` (host, 600) and is swarm-projected read-only into `shuffle-tools_1-2-0`. The file/value is FORBIDDEN to read or print (AGENTS.md MUST NOT; run-context §5: "cat of token files is FORBIDDEN").
- **EV-037-2 (UNVERIFIED):** Determining the live IRIS role (admin vs scoped) requires authenticating to IRIS with the token (e.g. `GET /api/…/me` or similar), which would consume the secret value. Because reading the token file is prohibited, the live role CANNOT be verified in this read-only, no-secret-read pass.
- **EV-037-3 (VERIFIED):** Design intent (per AGENTS.md Known Blockers / run-context) is least-privilege: the token should be a scoped IRIS account used only to create alerts, not a full admin. This is a documented intent, not a live-proven role.

## Backup-Rollback
Read-only. No token consumed.

## Stop conditions
Verifying the live role is owner/agent-gated by the token-read prohibition; escalation to operator to either (a) grant explicit read-and-probe authorization or (b) supply the role from IRIS admin console is the stop condition.

## Limitations
Live role cannot be proven without reading the secret; recorded as PARTIAL with the prohibition stated. The plan to move to a dedicated least-privilege account is 038.

## Verdict rationale
Intent is least-privilege; live role unverifiable under the no-secret-read rule → PARTIAL.
