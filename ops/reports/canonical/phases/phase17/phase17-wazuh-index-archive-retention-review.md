# Phase 17 Wazuh Index, Archive, and Retention Flow Review

Date: 2026-08-16

## Status: REVIEW COMPLETE - retention + noise findings

## Index inventory

| Index group | Size | Notes |
|---|---|---|
| wazuh-alerts-4.x-* | ~2GB total (7d rolling) | 08.09 peak 501MB |
| wazuh-archives-4.x-* | ~9.3GB total | 08.09 peak 2.6GB; 08.16 383MB partial |
| ElastiFlow flows | 1.4GB | separate rollover |

## Flow findings

1. **Archives >> alerts** (~9.3GB vs ~2GB): level-0 data dominates - consistent
   with Zeek (71k/day no rules) + SCA (2,215/day) + general syslog.
2. **08.09 archive spike (2.6GB)**: investigate (likely SO/zeek backlog day).
3. **Retention**: 7 days rolling (indices 08.07-08.16 present); no ILM seen for
   alerts/archives (manual template-based rolling).

## Recommendations

1. Add ILM policy: alerts 30d, archives 14d (or per policy review).
2. Zeek no-rule data: once zeek rules added (P17.09), archives/alerts balance
   improves; consider reducing SCA frequency if storage-driven.
3. Filebeat/archives shipping: verify daily (backlog item).

## Backlog

- ops/reports/phase17-index-noise-and-retention-backlog.md (created)

## No secrets
