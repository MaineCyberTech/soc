# Phase 27 Shuffle Malformed Event Branch

Date: 2026-08-24
Status: **SPECIFIED - UI IMPLEMENTATION** (API condition edits are stripped; verified).

## Spec (workflow editor)

1. Add a filter/condition node after the webhook trigger:
   - Branch A (valid): `rule.id in {122001,122002,122003}` AND `data.zeek.orig_h` AND
     `data.zeek.resp_h` present -> proceed to dedup -> IRIS.
   - Branch B (malformed): missing rule/source/destination -> log-only branch (Shuffle Tools
     Log) + malformed-input counter; NEVER routes to IRIS.
2. Metrics: malformed count surfaced in workflow execution log.

## Interim

- Malformed events would fail the IRIS HTTP action gracefully (no case created); the cron
  guardrail counts executions (not malformed) - a malformed flood would not trip the limit,
  so the UI branch remains the proper control.

## No secrets