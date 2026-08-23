# Phase 26 Retention Delete Observation

Date: 2026-08-23
Status: **OBSERVED - DELETES FIRING (not just projected)**

## 1. Actual ISM transitions

- **Deleted by archives-14d**: `wazuh-archives-4.x-2026.08.07`, `.08.08`, `.08.09` (ages
  crossed 14d after the P25 re-attach). 08-10 remains (14d birthday 08-24).
- Remaining archives: 08-10 + 08-15..08-23 (08-15..18 delete ~08-29..09-01).

## 2. Disk change (observed, not assumed)

| Metric | P25 (08-22) | P26 (08-23) |
|---|---|---|
| Node fs used | 84.7% | **79.5%** |
| Root disk | 84% | **79%** |

- ~5pp relief landed from retention deletes + reduced ingest.

## 3. Policy errors / snapshots

- No ISM policy errors observed (deletes completing). Snapshots unaffected (7d rolling window,
  42 snaps; latest snap-20260823-0017).

## 4. Flow retention

- ElastiFlow 14d policy active; flow index stable (~2.4GB).

## Verdict

- **PASS** - 14d retention is executing and delivering measured disk relief.

## No secrets