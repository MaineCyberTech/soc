# Phase 23 PVE222 Token Refresh and Capacity Reconciliation

Date: 2026-08-22
Status: **BLOCKED - REPLACEMENT TOKEN REQUIRED**.

## 1. Token state

- `pve222-api-healthcheck.sh`: API port reachable, **auth 401** (PVE222_API_TOKEN absent from
  ops/creds.env). Capacity visibility degraded since P20.
- Approval + replacement token required (change register C5).

## 2. Refresh procedure (when token provided)

1. Obtain token via Proxmox console (user with PVEVMAuditor/PVEVMAdmin minimal privilege) -
   NOT printed anywhere.
2. Add `PVE222_API_TOKEN=<value>` to ops/creds.env (mode 600).
3. Run `pve222-api-healthcheck.sh` -> expect PASS (port + auth + VM list).
4. Reconcile thin-pool/node reports; record expiry/rotation in creds inventory.

## 3. Capacity reconciliation (current best-effort)

- Thin pool report (08-19, node .187): OK. Historical .149 pool 87.84% - node reconciliation
  deferred until API auth restored (which host hosts which pool).

## 4. Decision

- **BLOCKED** on replacement token. Recheck each phase.

## Files
- `ops/reports/phase23-pve222-token-refresh.md` (this), `ops/reports/phase23-pve222-capacity-reconciliation.md`

## No secrets