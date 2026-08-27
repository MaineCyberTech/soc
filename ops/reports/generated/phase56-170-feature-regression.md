# Phase 56: Feature Regression (dedup + TTL + counter together)

**Prompt:** 170-feature-regression
**Generated (UTC):** 2026-08-28T00:25:00Z
**Operator (EDT):** 2026-08-27T20:25:00-0400
**Verdict:** BLOCKED

## Summary
Read-only inspection confirms all three governed features are currently DEFECTIVE/ABSENT in the live workflow: (1) dedup key `p53_dedup_%s_%s_%s_%s` (sid,src,dst,port) OMITS `proto` and `agent` → distinct-protocol/agent events falsely collapse (Phase 55 DUPLICATE defect, VERIFIED); (2) NO TTL/governed-expiry on any cache category; (3) counter is a non-atomic flag. Each requires a gated workflow code edit (122 dedup-fix, 139 ttl-write, 155 counter-increment). Regression status cannot be closed without those edits.

## Evidence
EV-170-1 (VERIFIED): Dedup key line ~120 = `p53_dedup_%s_%s_%s_%s` (sid,src,dst,port); `proto`/`agent` absent → false collapse.
EV-170-2 (VERIFIED): No TTL/`ttl`/`expir` token in source → governed TTL absent.
EV-170-3 (VERIFIED): Counter = `set_cache_value(value="1")` flag (line ~147) → not atomic.

## Backup / Rollback
No mutation. Revisions revert via Shuffle workflow history (gates 057-061, owner-only).

## Stop conditions
Dedup-fix (122), TTL-write (139), counter-increment (155) are owner-gated workflow code edits — not performed here.
Class-A `eb937a37` absent from live trigger list (drift VERIFIED) — independent of packet path but relevant to feature certification.

## Limitations
None.

## Verdict rationale
BLOCKED: all three governed features are defective/absent in source; their remediation is owner-gated workflow code (122/139/155). Regression cannot be certified read-only.
