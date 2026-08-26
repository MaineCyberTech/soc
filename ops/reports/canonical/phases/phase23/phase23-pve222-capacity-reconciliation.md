# Phase 23 PVE222 Capacity Reconciliation

Date: 2026-08-22
Status: **DEFERRED on token** (see phase23-pve222-token-refresh.md).

## Known state

- Thin pool report (2026-08-19, node .187): data pool OK (0.00% per report), PV free 206.93g.
- Historical reports referenced an 87.84% WARN pool (node .149) - not reconciled since API auth
  broke (P20).
- VM202 watch: no data (API 401).

## Reconciliation plan (post token)

1. List nodes + thin pools via API; identify which node carries the ~88% pool.
2. Generate fresh thinpool report; confirm thresholds (WARN 85 / ACTION 90 / EMERGENCY 95).
3. Document VM202/VM103 capacity alongside.

## No secrets