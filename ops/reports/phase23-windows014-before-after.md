# Phase 23 Windows 014 Before/After and Throttle Retirement

Date: 2026-08-22
Status: **BEFORE (THROTTLED) - AFTER PENDING** (apply blocked).

## Before (measured)

| Metric | Value |
|---|---|
| EID7 (endpoint-side proxy) | flood ongoing; 126 alerts/24h surviving throttle; archives suppressed |
| Rule-11 throttle | ACTIVE (4 msgs/24h; agent buffer flooded cycles ~13/24h) |
| EID1/10 | suppressed in archives |

## After targets (post apply of include policy)

- EID7 volume: >=99% drop endpoint-side (include-mode collects only suspicious combos).
- EID1/10: unchanged/flowing.
- Agent buffer: 0 flooded events/24h.
- Suspicious-sample behavior: test matrix from design review (23.04) satisfied.

## Rule-11 throttle decision

| State | Decision |
|---|---|
| Post-tune EID7 < 2K/24h + buffer clean for 24h | **RETIRE throttle** (restore default log analysis; remove suppression) - verify rule-11 volume normalizes |
| EID7 still high | RETAIN throttle + re-tune |
| EID1/10 degraded | RETAIN throttle + rollback config |

Throttle retirement procedure: confirm Wazuh rule-11 suppression no longer triggers (no
"average number of logs" messages for 48h after tuning) - no manual rule change needed;
suppression clears automatically when volume normalizes.

## Decision

- **BEFORE: FAIL** (flood throttled). **AFTER: PENDING** (endpoint access + approval).

## Files
- `ops/reports/phase23-windows014-before-after.md` (this), `ops/reports/phase23-rule11-throttle-decision.md`

## No secrets