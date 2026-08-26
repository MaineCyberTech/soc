# Phase 14 Low-Resource Audit

Date: 2026-08-16
Report: ops/reports/resource-efficiency-report-20260816-063347.md

## Status: HEALTHY - no urgent action; tuning backlog defined

## Host resources

| Metric | Value | Assessment |
|---|---|---|
| RAM | 15Gi total, 10Gi used, 4.4Gi available | OK (post-P10 expansion) |
| Swap | draining (45% -> lower) | improving |
| Disk / | 65% (50G free of 148G) | OK - watch |
| Thin pool .222 | 87.84% (WARN) | P14.15 |

## Docker memory (top consumers)

| Container | Memory | Notes |
|---|---|---|
| 3x indexer | ~1.8Gi each | OpenSearch JVM (expected) |
| shuffle-opensearch | 1.3Gi | 768Mi limit exceeded? (cgroup soft) |
| elastiflow | 830Mi | - |
| wazuh.master/worker | ~500Mi each | healthy |
| tenzir-node | 206Mi @ 5.65% CPU | highest CPU% |

## Disk top consumers

| Path | Size | Category |
|---|---|---|
| /opt/wazuh-backups/elasticsearch | 13G (90 entries) | ES snapshot repo - retention review |
| /opt/mct-security-stack/ops/backups | 4.4G | vm103 DB dumps - retention 14d |
| /opt/wazuh-backups (config tars) | ~1G | 14d retention OK |
| OpenSearch indices | ~11G archives + alerts | 7-day rolling |

## Noise sources

- Sysmon: LOW (013: 175/24h, 012: 452/24h) - no tuning needed.
- Alert noise: VaultCli FPs fixed (P14.07) - re-measuring.
- SCA summaries: informational, monthly review.

## Tuning backlog (no changes made - acceptance-gated)

1. ES snapshot repo (13G): add retention/rotation policy (currently unbounded).
2. shuffle-opensearch: raise mem_limit to 1.5Gi or verify soft-limit OK.
3. Indexer heap: 3x1.8Gi - consider jvm heap tuning on constrained hosts.
4. tenzir-node CPU: monitor (5.65%) - optional pause when idle.
5. Backups: keep 14d config retention; DB dumps reviewed monthly.

## No secrets

No secret values printed.
