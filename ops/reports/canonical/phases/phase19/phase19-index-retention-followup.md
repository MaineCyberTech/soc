# Phase 19 Index Retention Followup

Date: 2026-08-18
Status: **APPLIED (approved)** 2026-08-18 ~21:55 UTC.

## Correction to prior status

The cluster uses **OpenSearch ISM** (Index State Management), not Elasticsearch ILM.
Retention WAS already configured before this phase:
- `wazuh-retention` (via `wazuh-main` template, priority 300): alerts + archives delete at 30d.
- `elastiflow` policy: rollover (1d/20GB) + force_merge, delete at 30d.
- `wazuh-states-retention`: states.

P18's "no ILM / retention un-applied" assessment was inaccurate - policies existed.

## Current state

- Cluster ~11 GB today; ~2-3 GB/day combined growth while noise present.

## Applied changes (2026-08-18, approved)

| Index pattern | Policy | Delete after | Applied via |
|---|---|---|---|
| `wazuh-alerts-4.x-*` | `wazuh-retention` | **30d** (unchanged) | wazuh-main template |
| `wazuh-archives-4.x-*` | `wazuh-archives-14d` (NEW) | **14d** | new template `wazuh-archives-p19-retention` (priority 310 > 300) |
| `elastiflow-*` | `elastiflow` (updated) | **14d** (was 30d) | ISM policy update |

Notes:
- Existing indices keep their originally-assigned policy until re-created; new archives indices
  (from 08-19) pick up the 14d policy via the higher-priority template. Today's archive index
  stays at 30d (conservative).
- `wazuh-retention` now effectively governs alerts only.

## Security tradeoff (documented)

- Archives are the raw-event forensic store. Reducing from 30d to 14d shortens raw log
  retention for investigations. Mitigations: alerts (the triage signal) keep 30d; DFIR cases
  snapshot relevant evidence into IRIS/evidence store on creation; netflow 14d is sufficient
  for flow correlation. Revert path: point the archives template policy_id back to
  `wazuh-retention` (or raise to a longer window) if client requirements demand longer.

## Sequencing note

Applied alongside the Zeek v2 deploy. Noise fixes (Zeek done, macOS pending) will further
reduce daily growth; re-measure next phase.

## No secrets