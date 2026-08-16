# Change Window

Window: 2026-08-11 05:00-07:00 UTC (operator working session)
Stack: Wazuh 4.14.7 multi-node + stack services at /opt/mct-security-stack

## Scope

| Workstream | Risk | Wazuh impact | Rollback |
|---|---|---|---|
| Alert routing/noise reduction | medium | analysisd restart if rule changes applied | restore local_rules.xml backup + restart |
| Drills D2-D8 | low | test events only | none needed (test IOC expiry) |
| Credential rotation | high | indexer auth if WAZUH_ADMIN_PASSWORD rotated | keep old value until validation passes |
| VM 103 backup automation | low | none | none (scripts only) |
| Scorecard/reporting | low | none | none |
| Capacity planning | low | none | none (no moves without approval) |

## Pre-change gate

- [ ] Indexer green (verified: green, 3 nodes)
- [ ] Full-stack healthcheck 0 FAIL (verified 2026-08-11)
- [ ] Shuffle healthcheck PASS (verified)
- [ ] Backup freshness PASS (verified)
- [ ] Port snapshot captured (ops/reports/phase4-ports-*.txt)
- [ ] Config backup of Wazuh rules/lists before any rule change

## Rules

1. One workstream at a time; verify after each.
2. No `docker compose down -v` ever.
3. No Wazuh rule change without: backup -> wazuh-logtest -> analysisd restart both nodes -> before/after counts.
4. Credential rotation: one credential at a time, validate before next.
5. Class A paths (OpenCanary, MISP IOC, unknown exporter, lateral movement) must never be weakened.
6. Any destructive SOAR action: manual approval only.

## Post-window verification

```bash
/opt/mct-security-stack/ops/scripts/full-stack-healthcheck.sh
/opt/mct-security-stack/ops/scripts/shuffle-healthcheck.sh
/opt/mct-security-stack/ops/scripts/backup-dr-audit.sh
/opt/mct-security-stack/ops/scripts/soc-smoke-test.sh --dry-run
```
