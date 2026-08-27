# Phase 54: Protocol Collision

**Prompt:** 123-collision-proto
**Generated (UTC):** 2026-08-27T21:28:32Z
**Operator (EDT):** 2026-08-27T17:28:32-0400
**Verdict:** PARTIAL

## Summary
Verify protocol is a distinctness dimension so two events identical in sid/src/dst/port but
differing in protocol are not collapsed. FINDING: `proto` is captured into the IRIS body
(line 163) but is NOT included in the dedup key (line 120). Two events differing only by protocol
would share the same 5-tuple key and the second would be emitted as DUPLICATE.

## Evidence
- E1 — `/tmp/opencode/pkt_code.py` line 120: dedup key omits `proto`.
- E2 — line 163: `proto` only flows into `alert_source_content` for the destination object, not into dedup.
- E3 — live `p53_dedup` keys contain no protocol segment (format `p53_dedup_<sid>_<src>_<dst>_<port>`).

## Backup / Rollback
Read-only; N/A.

## Stop conditions
None (analysis only).

## Limitations
Protocol-level collision is not prevented by the current dedup key; treated as a gap to be closed
by adding `proto` to the dedup tuple (orchestrator change, not performed here).

## Verdict rationale
Proto distinctness is not implemented in the dedup key; flagged as a real gap (PARTIAL).
