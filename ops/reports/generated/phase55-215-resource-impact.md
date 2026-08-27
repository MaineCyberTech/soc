# Phase 55: Resource Impact

**Prompt:** 215-resource-impact
**Generated (UTC):** 2026-08-27T23:10:00Z
**Operator (EDT):** 2026-08-27T19:10:00-0400
**Verdict:** DONE

## Summary
Resource impact of the Wazuh/Shuffle/IRIS routing stack, measured read-only via `docker stats --no-stream`.

## Evidence
- **EV-RES-1** [VERIFIED] Snapshot (no-stream):
  - `shuffle-opensearch`: 1.69% CPU, 1.209GiB / 1.5GiB RAM (single-node datastore, the largest consumer).
  - `shuffle-backend`: 1.06% CPU, 85.67MiB RAM.
  - `iriswebapp_nginx`: 4.87% CPU, 16.89MiB RAM; `iriswebapp_app` 0.28% / 35.3MiB; `iriswebapp_worker` 0.21% / 16.07MiB.
  - `shuffle-tools_1-2-0` (2 replicas): ~0.01% CPU, ~84MiB each.
  - `shuffle-orborus`: 0.17% CPU, 24.85MiB; `shuffle-workers`: 0.54% CPU, 62.5MiB.
  - `multi-node-wazuh.master-1`: 0.48% CPU, 668.6MiB; `worker-1`: 0.19% CPU, 444MiB.
  - `wazuh-cloudflared`: 0.16% CPU, 24.95MiB.
  - Total host RAM 15.19GiB; no container near its limit. Disk/ watermarks NOT inspected (gate: disk).

## Backup-Rollback
None; read-only.

## Stop conditions
None. (Disk watermark / ISM investigation is a separate gated layer; not performed.)

## Limitations
Single snapshot, not a sustained profile. CPU% is instantaneous. RAM headroom is ample. No disk/watermark check (gated; advisory-only per AGENTS).

## Verdict rationale
Resource footprint captured read-only across Wazuh/Shuffle/IRIS; all within limits. Verdict DONE.
