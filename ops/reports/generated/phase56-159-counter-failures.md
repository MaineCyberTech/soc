# Phase 56: Failure Counters (Auth/Target/Datastore/Unknown)

**Prompt:** 159-counter-failures
**Generated (UTC):** 2026-08-28T00:12:00Z
**Operator (EDT):** 2026-08-27T20:12:00-0400
**Verdict:** PARTIAL

## Summary
Read-only analysis of failure accounting across auth/target/datastore/unknown failure modes. Findings:
- **Counter write failure:** handled — `set_cache_value` wrapped, `except → COUNTER_FAIL` + dead-letter + notify (lines 143–149, 204–210). VERIFIED.
- **Datastore read failure (dedup):** handled — `DATASTORE_READ_FAIL` + dead-letter + notify (lines 121–127, 204–210). VERIFIED.
- **Auth/Target failure:** emitted as `AUTH_FAILED`/`TARGET_FAILED` + dead-letter + notify (lines 153–154, 194–196, 204–210). VERIFIED. **BUT** the routing counter flag (line 147) was already set *before* delivery and is NOT rolled back by `fail()` (line 135 only reverts dedup). So failure accounting is corrupted: a packet that fails auth/target still leaves the `p53_packet_routed` flag asserted. This breaks failure-vs-success accounting integrity.
- **Unknown:** top-level `except → UNKNOWN` + dead-letter + notify (lines 199–210). VERIFIED.

Remediation (destination-gated atomic counter) owned by gate **155 (counter-increment)** → BLOCKED.

## Evidence
- EV-SRC (VERIFIED): Live workflow source inspected.
- EV-CFAIL (VERIFIED): `COUNTER_FAIL` path (lines 147–149) + generic failure handling (lines 204–210) write `p53_deadletter` and `p53_notifications`.
- EV-AUTH (VERIFIED): `AUTH_FAILED` (lines 153–154, 194–195), `TARGET_FAILED` (lines 183–184, 196).
- EV-CORRUPT (VERIFIED): Counter flag set at line 147 before delivery; `fail()` rolls back only dedup (line 135), not the counter → failed deliveries still assert the flag.
- EV-OS (UNVERIFIED): OpenSearch unreachable (HTTP 000) → no backend failure-metric cross-check.

## Backup / Rollback
Read-only. No mutations. Secret referenced by ID/path only.

## Stop conditions
Gate 155 (counter-increment) BLOCKED — not edited. No other gated action. No webhook GET.

## Limitations
Failure-emission paths verified; but success/counter accounting integrity is broken by the pre-delivery, non-rolled-back flag. Cannot fix without BLOCKED 155.

## Verdict rationale
Failure handling paths VERIFIED present, but counter-not-gatewayed-to-success defect corrupts accounting. PARTIAL (analysis complete; non-conforming).

## Evidence separation
- REST / API: EV-SRC.
- Webhook: trigger metadata only (`736b7410`); not invoked.
- Wazuh integratord / sensor-origin: not implicated.
- OpenSearch: EV-OS separate (unreachable).
