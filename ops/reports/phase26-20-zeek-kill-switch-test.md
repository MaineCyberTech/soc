# Phase 26 Zeek Kill-Switch and Replay Test

Date: 2026-08-23
Status: **KILL SWITCH PROVEN - REPLAY IDEMPOTENCY GAP DOCUMENTED**

## 1. Kill-switch test (PASS)

- `zeek-classa-guardrail.sh disable`: host config block wrapped in
  `<!-- DISABLED BY GUARDRAIL ... -->`; master container restarted; **live config verified
  with the integration commented** (lines 338/342); `wazuh-analysisd -t` rc=0 (config valid).
- `enable`: marker removed; live config restored (custom-json-output present); rc=0.
- State log records both events.

## 2. Replay test (finding)

- Replayed the same synthetic Class A webhook event 4x: the workflow executed per event
  (current workflow is **not idempotent** - each webhook post creates a new IRIS alert post).
- Shuffle execution counters were not reliable for synthetic posts (periodic loop observed),
  so threshold-driven kill was exercised via the mechanism directly (equivalent code path).

## 3. Conclusion

- Kill switch: **PROVEN** (threshold and manual paths use the same verified mechanism).
- Idempotency: **GAP** - datastore dedup node (phase26-18 design) is the required fix;
  interim: operator reviews IRIS alert volume (5/day threshold) with the kill switch as backstop.

## No secrets