# Phase 56: State Validator

**Prompt:** 205-state-validator
**Generated (UTC):** 2026-08-27T21:30:00Z
**Operator (EDT):** 2026-08-27T17:30:00-0400
**Verdict:** PARTIAL

## Summary
Read-only inspection confirms the validator rejects malformed and missing/invalid ROUTED outcomes and only emits ROUTED on HTTP 200/201 with a parsed destination object id. Hardening the validator (e.g., explicit schema validation of the IRIS response, rejecting partial ROUTED) is a workflow code edit, gated.

## Evidence
- EV-WF-2 (VERIFIED): `MALFORMED` emitted when `sid is None` (missing required input) — rejects malformed up front.
- EV-WF-4 (VERIFIED): `AUTH_FAILED` when token unavailable or 401/403; `TARGET_FAILED` on non-2xx; `ROUTED` ONLY on `status in (200,201)` with `destination_object_id` parsed from `data.alert_id`/`alert_id`/`message` (lines 186-196). Missing/invalid ROUTED is rejected (falls to TARGET_FAILED/AUTH_FAILED).
- EV-WF-6 (VERIFIED): rejected/invalid outcomes are dead-lettered + notified (recoverable).
- EV-TRIG-1 (VERIFIED): only `suricata-eve-in` webhook live/running; validator executes only on that trigger intake.

## Backup / Rollback
N/A (read-only). Validator change reversible via workflow revision.

## Stop conditions
Workflow code edit gate (run-context §4). Live validation harness run deferred (would create IRIS objects).

## Limitations
- No explicit JSON-schema assertion on the IRIS response body; object-id extraction is best-effort (falls back to `message`).
- Validator not exercised with adversarial/partial payloads live.

## Verdict rationale
Core rejection logic VERIFIED read-only (malformed + missing/invalid ROUTED rejected). Hardening gated → PARTIAL.
