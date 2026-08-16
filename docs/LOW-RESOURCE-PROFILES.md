# Low-Resource Profiles

Date: 2026-08-16 (Phase 14)

## Lab/Pilot Profile (current)

- Weekly scheduled Greenbone scans (06:00 Sunday) - non-invasive.
- Sysmon measurement-first (low volume, no tuning needed).
- Indexer: 3 nodes x 1.8Gi (default heap).
- Backup retention: config 14d, DB dumps reviewed monthly.
- Watch: ES snapshot repo growth (13G) - add rotation.

## Production Minimal Profile (client-pilot viable)

- Preserve: Class A/B alerting, endpoint health, SCA, critical alerts,
  backup checks, client scorecard.
- Digest/archive lower-value noise (no telemetry removal without acceptance).
- Single indexer or fewer shards on constrained hosts.
- Weekly Greenbone on client targets ONLY with signed authorization.

## Expansion Profile (post-readiness gates)

- Windows dashboards W1/W2 + PS ScriptBlockLogging after 7-day FP re-measure.
- Client-specific Greenbone schedules with authorization.
- Canarytoken/deception after T1 validation.

## Thresholds/alerts (recommended)

| Metric | WARN | ACTION | EMERGENCY |
|---|---|---|---|
| Host RAM available | < 2Gi | < 1Gi | < 512Mi |
| Disk / | 80% | 90% | 95% |
| Thin pool .222 | 85% | 90% | 95% |
| ES snapshot repo | 10G | 15G | 20G |
| Indexer heap | - | 2.5Gi/node | - |

## Tuning runbook

- ops/runbooks/resource-efficiency-tuning.md

## No secrets
