# Phase 55: P54 Bind Fallback

**Prompt:** 012-p54-bind
**Generated (UTC):** 2026-08-27T22:58:56Z
**Operator (EDT):** 2026-08-27T18:58:56-0400
**Verdict:** DEFERRED

## Summary
Assessed the legacy `/shuffle-files` bind-mount fallback: its exposure, consumers, and retirement decision. The inspection is complete (VERIFIED), but the retirement decision is owner-DEFERRED (P54 055), so the actionable outcome is DEFERRED.

## Evidence
- EV-BD1 — `docker service inspect shuffle-tools_1-2-0`: Mount Target `/shuffle-files`, Source `/opt/mct-security-stack/data/shuffle/files`, ReadOnly true, Type bind (VERIFIED).
- EV-BD2 — Exposure: bind is read-only and scoped to the single host path; consumed only by `shuffle-tools_1-2-0` (the same service that also holds the secret). No other service mounts it (VERIFIED via service inspect).
- EV-BD3 — Users: the workflow token-load candidates are `["/shuffle-files/iris-shuffle.env", "/run/secrets/iris-shuffle.env"]`; both paths are valid, so the bind is a redundant fallback to the secret (VERIFIED by design).
- EV-BD4 — Retirement decision: DEFERRED removal (P54 report 055) — explicit owner decision to retain as fallback (carried VERIFIED).

## Backup / Rollback
Removal (if later approved) is reversible: re-add the bind mount to the service spec. No change made now.

## Stop conditions
Removing the bind mount is a service-spec change best done with owner sign-off; recorded as DEFERRED. Not performed.

## Limitations
This report documents the fallback; it does not prove the secret alone is sufficient under all failure modes (that is a separate re-proof layer). Bind remains as explicit fallback per owner.

## Verdict rationale
Inspection VERIFIED, but the retirement/removal decision is owner-DEFERRED per P54 055; the report's actionable verdict is therefore DEFERRED, not a failure.
