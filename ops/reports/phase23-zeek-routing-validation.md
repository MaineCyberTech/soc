# Phase 23 Zeek Routing Case-Volume Validation

Date: 2026-08-22
Status: **METHOD READY - WINDOW NOT OPEN** (enable pending approval).

## Measurement plan (first 24h after enable)

| Metric | Target |
|---|---|
| Shuffle executions | <= 10 |
| IRIS cases created | <= 5 (Class A only) |
| Duplicates (dedup window) | 0 |
| False positives | review each case vs template |
| Stop threshold | > 5 cases/day -> disable filter + notify |

## Rollback triggers

- > 5 cases/day; EID/rule volume spike; IRIS case spam; Shuffle/IRIS health regression.

## Evidence

- Case list + dedup log + workflow execution log recorded in this report once window opens.

## No secrets