# Phase 28 Snapshot Inventory

Date: 2026-08-24

## Snapshot repository

- FS type at /snapshots (docker volume). 42 snapshots; latest snap-20260824-1517 (SUCCESS, 54 indices).
- Policy: 5-hourly cadence; 7-day window (rolling). S3 DR repo exists (nyc3, P25) for bundle.

## Index inventory (live, by family)

| Family | Count | Notes |
|---|---|---|
| wazuh-alerts-4.x-* | ~15 | daily indices |
| wazuh-archives-4.x-* | ~10 | daily; 14d ISM retention |
| wazuh-states-inventory-* | ~14 | per-type; 30d-ish retention |
| wazuh-states-vulnerabilities-* | 1 | |
| elastiflow-{flow,metric,path,telemetry_flow}-* | 4 rollover series | rollover aliases |
| .kibana_1 + system | few | dashboards |
| .opendistro-* history | few | ISM/AD history |
| Total | **65 indices / ~21GB** | |

## Compatibility

- min index compat 7.0.0; same-major restore only; plugin compatibility matrix in 23.
- **0 data streams**; **21 templates**; aliases for rollover series + .kibana + ISM history.

## Exclusions/global state

- include_global_state=false for scratch; explicit decision for .opendistro_security
  (admin hashes) - do not restore to avoid cred lockout.

## No secrets