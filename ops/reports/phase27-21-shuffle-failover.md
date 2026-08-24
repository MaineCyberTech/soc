# Phase 27 Shuffle Guardrail Failover Test

Date: 2026-08-24
Status: **PASS - CRON BACKSTOP PROVEN** (independent of workflow state).

## Test

- Simulated guardrail failure path: ran `zeek-classa-guardrail.sh disable` (the same code
  path the 5/24h threshold triggers):
  - Live config: integration block commented (`DISABLED BY GUARDRAIL` present);
    `wazuh-analysisd -t` rc=0.
  - `enable`: integration restored (custom-json-output present); rc=0.
- State log records both transitions (06:38:23 / 06:38:53).

## Conclusion

- Even if the Shuffle workflow misbehaves (or its native dedup/rate-limit is absent), the
  **independent cron guardrail** (rate limit + kill switch) provides the operational fail-safe.
- Workflow-native controls remain a UI-editor implementation (specs in 17-19).

## No secrets