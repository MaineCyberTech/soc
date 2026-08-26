# Phase 4 Noise After (post-tuning)

Date: 2026-08-11, measurement after osquery 24010 suppression (applied 05:28-05:32 UTC)

## Measurement caveat (disclosed)

- Suppression applied mid-window; a full 24h post-change window requires waiting.
- First verification uses post-restart timestamps (>= 2026-08-11T05:32Z).

## Verified

- **Rule 24010 (osquery inventory): 0 alerts since 05:32Z** (was ~11k/hour, 263k/24h).
- Child rules still functional: 24013 (low disk) validated at level 4 via logtest.
- Class A paths untouched (OpenCanary 1210xx, MISP 1211xx verified in logs).
- Cluster green; analysisd restarted on both nodes with no rule load errors (8508 rules).

## Expected post-change totals

| metric | before/24h | expected after |
|---|---|---|
| total alerts | 520,670 | ~257k (-50.6%) |
| osquery 24010 | 263,490 | ~0 (archived only) |
| UniFi family | ~238k | unchanged (proposed C digest not applied) |
| mct-portal/auditd | ~18k | unchanged |

## Archive retention

24010 events continue into `wazuh-archives-*` (archive-only behavior) - full
telemetry retained for investigations, only alerting removed.

## Re-baseline procedure

```bash
# after 24h of steady state:
/opt/mct-security-stack/ops/scripts/alert-volume-by-rule.sh 24
cp $(ls -t ops/reports/alert-volume-by-rule-* | head -1) ops/reports/phase4-noise-after-full.md
```
