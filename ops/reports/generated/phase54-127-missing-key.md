# Phase 54: Missing Key

**Prompt:** 127-missing-key
**Generated (UTC):** 2026-08-27T21:28:32Z
**Operator (EDT):** 2026-08-27T17:28:32-0400
**Verdict:** DONE

## Summary
Ensure a missing required key fails closed (no route). The workflow fails closed on every key
absence: missing `sid` → MALFORMED; missing IRIS token → AUTH_FAILED; any unhandled exception →
UNKNOWN plus dead-letter + notification (lines 199-210).

## Evidence
- E1 — `/tmp/opencode/pkt_code.py` lines 100-102: `sid is None` → emit MALFORMED (fail closed, no route).
- E2 — lines 152-154: `token` unavailable → AUTH_FAILED (fail closed).
- E3 — lines 199-210: top-level exception → UNKNOWN + deadletter + notify.

## Backup / Rollback
Read-only; N/A.

## Stop conditions
None.

## Limitations
Fail-closed verified for sid, token, and exceptions. (Note: src/dst/port may be None and still form
a key; only sid is the hard gate.)

## Verdict rationale
Missing key is handled fail-closed across all critical paths.
