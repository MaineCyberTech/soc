# Phase 56: ROUTED Counter (Increment Only Destination-Backed Success)

**Prompt:** 158-counter-routed
**Generated (UTC):** 2026-08-28T00:12:00Z
**Operator (EDT):** 2026-08-27T20:12:00-0400
**Verdict:** PARTIAL

## Summary
Read-only analysis of whether the routing counter increments ONLY on a destination-backed success (IRIS `ROUTED`, HTTP 200/201). **Defect confirmed:** the counter flag is set at line 147, which executes *before* the IRIS delivery section (section 7, lines 151–196). Worse, on delivery failure the `fail()` helper (lines 132–138) only rolls back the dedup mark — it does **NOT** roll back the counter flag. So the flag is asserted even when `AUTH_FAILED`/`TARGET_FAILED` occur, and remains set incorrectly. This violates "increment only destination-backed success." Remediation (atomic, destination-gated increment) is owned by gate **155 (counter-increment)** → BLOCKED.

## Evidence
- EV-SRC (VERIFIED): Live workflow source inspected.
- EV-ORDER (VERIFIED): Counter `set_cache_value(key="p53_packet_routed", value="1", ...)` at line 147 precedes IRIS delivery (section 7). Flag set regardless of delivery outcome.
- EV-NOROLLBACK (VERIFIED): `fail()` (lines 132–138) deletes only `dedup_key` (line 135); counter key never deleted/rolled back on `AUTH_FAILED`/`TARGET_FAILED`/`COUNTER_FAIL`.
- EV-ROUTED (VERIFIED): `ROUTED` emitted only at lines 186–193 (HTTP 200/201). Counter is NOT gated on this.

## Backup / Rollback
Read-only. No mutations. Secret referenced by ID/path only.

## Stop conditions
Gate 155 (counter-increment) BLOCKED — not edited. No other gated action. No webhook GET. (Note: carryover ROUTED proofs — exec `2ce46d4a…`→IRIS 67, `19791f62…`→IRIS 68 — are referenced, not re-created.)

## Limitations
Counter-not-destination-gated defect verified. Cannot fix without workflow mutation (BLOCKED 155). No new IRIS ROUTED object created this pack (overlay forbids).

## Verdict rationale
Defect VERIFIED: counter flag set before and not rolled back on delivery failure. Does not meet "destination-backed only." PARTIAL (analysis complete; behavior non-conforming).

## Evidence separation
- REST / API: EV-SRC (read-only).
- Webhook / ROUTED: only carryover ROUTED proofs referenced (IRIS 67/68); trigger `736b7410` metadata read, not invoked.
- Wazuh integratord / sensor-origin: not implicated.
