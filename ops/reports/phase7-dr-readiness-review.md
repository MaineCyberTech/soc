# Phase 7 DR Readiness Review

Date: 2026-08-12

## Status: READY-TO-EXECUTE (RAM-tight but feasible)

| Resource | Required | Available | Verdict |
|---|---|---|---|
| Disk | ~10 GB | 19 GB free | OK |
| RAM (scratch OpenSearch) | 2-4 GB | ~1 GB free + swap | TIGHT - use 1.5G heap + swap, or run after RAM increase |
| Snapshots | latest SUCCESS | snap-20260812-0017 (21 total) | OK |
| IRIS dump | present | 3 dumps (36K each) | OK |
| MISP dump | present | 2 dumps (149MB) | OK |
| Greenbone dump | present | 1 dump (1.8GB) | OK |
| Config backups | present | wazuh-config + phase2 bundles | OK |

## Validation order (dr-scratch-restore-execution.md)

1. OpenSearch snapshot -> scratch (ports 19200+)
2. Config extracts (wazuh-config, phase2)
3. IRIS/MISP/Greenbone DB restore (scratch containers)

## Blocker

- RAM headroom ~1 GB - scratch OpenSearch may increase swap pressure.
- Execute after VM101 RAM increase (B2) OR on a separate host.

## Next actions

ops/runbooks/phase7-dr-scratch-restore-next-actions.md
