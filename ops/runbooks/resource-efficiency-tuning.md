# Resource Efficiency Tuning Runbook

## Targets

- Disk below warning threshold.
- Swap trending down.
- Thin pool below action threshold.
- Windows high-volume noise measured before broad rollout.

## Tuning levers (with acceptance gates)

| Lever | Change | Acceptance |
|---|---|---|
| ES snapshot retention | rotate/expire old snapshots (>14d) | verify DR restore still works |
| shuffle-opensearch mem_limit | raise to 1.5Gi (or 2Gi) | verify Shuffle health |
| Indexer JVM heap | tune per-host | verify indexer green |
| tenzir-node | pause when idle | verify flow collection unaffected |
| Sysmon filters | only after 7-day measurement | keep EID 1/7/10 |
| Wazuh rule levels | only documented FP suppressions | client-safe review |

## Procedure

1. Run ops/scripts/resource-efficiency-report.sh.
2. Compare against thresholds (LOW-RESOURCE-PROFILES.md).
3. Apply single lever -> verify healthcheck PASS -> record in change control.

## No secrets
