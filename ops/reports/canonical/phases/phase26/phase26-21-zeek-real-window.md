# Phase 26 Zeek Real Case Window

Date: 2026-08-23
Status: **WINDOW OPEN - REAL CASES: 0** (routing enabled since 07:15 UTC 08-22).

## Measurements

| Metric | Value |
|---|---|
| Real IRIS cases (Class A) | **0** (no real SSH/SMB/RDP alerts since enable) |
| Shuffle executions (24h) | 2-4 (synthetic test artifacts; periodic loop) |
| Suppressions | n/a (no volume) |
| Malformed events | 0 observed |
| Failures | 0 (all FINISHED) |
| False positives | n/a (no real cases) |

## Interpretation

- Class A alert rate is ~0-1/day (clean network) - the window will accrue slowly; the
  guardrail + kill switch + operator threshold stand ready for any burst.

## No secrets