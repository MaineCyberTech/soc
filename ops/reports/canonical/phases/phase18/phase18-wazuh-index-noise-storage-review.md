# Phase 18 Wazuh Index Noise and Storage Review

Date: 2026-08-17

## Status: ARCHIVES DOMINATED BY LEVEL-0 (Zeek + macOS flood)

## Index data

| Index | Size | Notes |
|---|---|---|
| wazuh-alerts-4.x-* | ~2GB | 7d rolling |
| wazuh-archives-4.x-* | ~10.3GB | 7d rolling; 08.09 peak 2.6GB |
| ElastiFlow flows | 1.4GB | separate |

## Noise contributors (archives)

| Source | Daily docs | Storage impact |
|---|---|---|
| Zeek conn (agent 008) | 10k+ (uncapped) | HIGH - level-0, now rule-covered (P18.03) |
| macOS flood (agent 015) | 10k+ | HIGH - level-0, default agent localfile |
| SCA | ~24/day | LOW |
| 120537 Redis loop | 2.5k/day | MODERATE (level lowered P18.12) |

## Findings

1. Zeek: now HAS rules (P18.03) - alerts will grow; archives still store all.
2. macOS flood: 10k+/day level-0 - needs agent-local fix (outside stack).
3. No ILM on alerts/archives (rolling template only).

## Recommendations

1. ILM: alerts 30d, archives 14d (approval-gated apply).
2. macOS: document agent-local ossec.conf removal of default macos localfile.
3. Zeek: keep full archives (investigation value); rules give alert signal.

## Files

- ops/reports/phase18-index-retention-action-plan.md (created)

## No secrets
