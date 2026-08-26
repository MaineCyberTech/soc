# Phase 24 Zeek Case-Volume Validation

Date: 2026-08-22
Status: **METHOD READY - WINDOW NOT OPEN** (enable pending approval).

## Measurement plan (24h after enable)

| Metric | Target |
|---|---|
| Shuffle executions | <= 10 |
| IRIS cases | <= 5 (Class A only) |
| Duplicates | 0 (dedup window) |
| False positives | reviewed per case |
| Stop threshold | > 5 cases/day -> disable + notify |

## Rollback triggers

- > 5 cases/day; volume spike; IRIS spam; Shuffle/IRIS health regression.

## Evidence

- Case list + dedup log + workflow execution log recorded here once window opens.

## No secrets