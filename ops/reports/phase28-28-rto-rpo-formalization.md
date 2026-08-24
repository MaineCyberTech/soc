# Phase 28 RTO / RPO Formalization

Date: 2026-08-24

## Evidence-backed (by scope)

| Scope | RPO | RTO (observed) | Evidence |
|---|---|---|---|
| Config bundle | <= 24h (daily 04:00) | < 1 min (download/checksum/extract) | P25 |
| Single small index | snapshot point-in-time | seconds (wait_for_completion) | P26 (114/114) |
| Multi-index (3 states) | snapshot point-in-time | seconds | P27 (114/447/2248; cross-index) |
| Full cluster | snapshot point-in-time | **UNPROVEN** | runbook only (26); no target |

## Unproven assumptions (must be closed before full-cluster RTO claims)

1. Same-major restore of ALL indices incl. .kibana + system indices.
2. Template/alias re-creation on scratch.
3. App reconnect (Wazuh/IRIS/dashboard) timing.
4. Large-index (elastiflow ~2.8GB, archives ~3.9GB) restore time on scratch hardware.
5. Security bootstrap on isolated target.

## Formal statement

- **RPO <= 24h** (daily bundle) / **<= 5h** (index snapshots). **RTO per-scope**: config < 1 min,
  small/multi-index seconds. **Full-cluster RTO: NOT CLAIMED** pending approved drill.

## No secrets