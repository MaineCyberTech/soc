# Phase 27 Zeek Real Case Window

Date: 2026-08-24
Status: **WINDOW CONTINUES - REAL CASES: 0** (routing enabled 08-22 07:15 UTC).

## Measurements (since enable)

| Metric | Value |
|---|---|
| Real Class A alerts (Wazuh rule 122001-122003) | **0** |
| Real IRIS cases | 0 |
| Guardrail executions (24h) | 4 (synthetic/periodic artifacts) |
| Suppressions | n/a (no volume) |
| Malformed events | 0 observed |
| Failures | 0 |
| False positives | n/a |

## Interpretation

- Clean network; Class A rate ~0/day. Guardrail (limit 5/day + kill switch) stands ready;
  dedup/rate-limit native nodes = UI implementation (specs 17-19).

## No secrets