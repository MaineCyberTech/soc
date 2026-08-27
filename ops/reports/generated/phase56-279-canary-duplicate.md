# Phase 56: Duplicate Canary

**Prompt:** 279-canary-duplicate
**Generated (UTC):** 2026-08-27T23:29:49Z
**Operator (EDT):** 2026-08-27T19:29:49-0400
**Verdict:** BLOCKED

## Summary
Read-only inspection of the duplicate-canary design (asserting a single IRIS object for duplicate/distinct-protocol events). The known dedup defect (key omits `proto`+`agent`) is confirmed from source/carryover; a live duplicate canary is EXECUTION-gated and NOT run.

## Evidence
### REST / Webhook (read-only — NO GET on webhook URL)
- EV-WBH-19 (VERIFIED, carryover): Phase 55 defect — DUPLICATE dedup key omits `proto` and `agent`, causing distinct-protocol/agent events to be falsely collapsed. Overlay requires dedup identity to include protocol AND an explicitly governed observer identity policy.
- EV-WBH-20 (VERIFIED): `suricata-packet-routing` (`e133a645…`) active (273); dedup logic lives in its `execute_python` node — source read-only-visible, edits owner-gated (gate rule §4: dedup-fix 122 → BLOCKED).

### Sensor-origin (read-only)
- EV-SNR-18 (VERIFIED): duplicate canary would reuse sensor agent 016 events with varying `proto`/`agent` to prove single-object vs collapse.

### Wazuh integratord (read-only)
- EV-INT-22 (VERIFIED): distinct-protocol collapse would surface via integratord→Shuffle→IRIS; Class-A hook non-live (272) for that lane.

## Backup-Rollback
No mutation (read-only). N/A. If dedup-fix later applied: workflow-edit gate (122) + atomic counter requirement (counter must not be a boolean flag — Phase 55 defect).

## Stop conditions
Canary EXECUTION (266-288) requires signed Class-A approval + Class-A certified; live duplicate canary is canary work → BLOCKED. Workflow dedup edits also owner-gated. Marked BLOCKED — legitimate gate.

## Limitations
No duplicate canary executed; dedup defect confirmed read-only from carryover + source, not re-derived live.

## Verdict rationale
Duplicate canary is canary-execution, gated; dedup defect inspected read-only. Verdict BLOCKED.
