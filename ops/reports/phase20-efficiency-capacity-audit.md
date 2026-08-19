# Phase 20 Efficiency, Capacity, and Low-Resource Audit

Date: 2026-08-19

## 1. RAM / swap / disk

| Resource | Value | Status |
|---|---|---|
| Memory | 11.2 GB / 15.5 GB (72%) used | OK |
| Swap | 3,980M / 8,191M used (49%) | **WARN** (sustained; was 52% in P19) |
| Root disk | 76% used | OK (trending up from 75%) |

## 2. Docker memory-heavy services

| Container | Mem |
|---|---|
| wazuh3.indexer | 1.85 GiB |
| wazuh2.indexer | 1.56 GiB |
| wazuh1.indexer | 1.45 GiB |
| shuffle-opensearch | 1.33 GiB |
| wazuh.master | 854 MiB |
| elastiflow | 752 MiB |
| wazuh.worker | 494 MiB |
| tenzir-node | 376 MiB |

Indexers (3x ~1.5-1.8GB) + shuffle-opensearch (1.33GB) dominate. Indexer heap was tuned in P17.

## 3. Index / archive impact after Phase 19

- Zeek v2.2: alert rate ~0/min (was 10-11K/hr) - **major alert-index load reduction**.
- Archives 08-19: 749K docs (1.4GB) by 06:00 - driven by Sysmon EventID 7 flood from 014
  (~514K/24h while active) + zeek-forward + journald. macOS 015 no longer contributing (offline).
- 014 EventID 7 flood, if resumed, projects ~1.6M docs/day - **storage risk** (R2).

## 4. macOS flood and Zeek tuning impact

- macOS flood: resolved-at-source only pending fix (agent offline, ~0 archives/day now, but
  would return on reconnect without fix).
- Zeek tuning: v2.2 eliminated ~10K alerts/hr; retention now 14d archives/flow (validated).

## 5. Proxmox thin pool and VM202

- Thin pool report (08-19): data pool **OK (0.00%)** on queried node (.187); PV free 206.93g.
  Caveat: historical .149 thin pool was 87.84% WARN - the report script queries a different
  node; **reconcile which node hosts the 87.84% pool**.
- PVE222 API auth **FAIL (401)** - PVE222_API_TOKEN missing/expired; VM202 capacity visibility
  degraded (action item).

## 6. Low-resource action plan

See `ops/reports/phase20-low-resource-action-plan.md`.

## Verdict

Load is manageable but swap pressure persists and a new Windows telemetry flood (014) is the
largest single storage risk. No immediate capacity emergency; fixes are operator-driven.

## No secrets