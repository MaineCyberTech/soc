# Phase 41 Dashboard Runtime Baseline — Environment And Inventory

**Report ID:** phase41-61-dashboard-runtime-baseline
**Phase:** 41
**Title:** DASH-BL-41-01 — Dashboard Runtime Environment Baseline: Container multi-node-wazuh.dashboard-1 Confirmed On Host Port 127.0.0.1:443→5601/tcp (docker ps + ss Live), Auth Method Documented Credentials-By-Reference, Saved-Object Inventory Fixed At 8 Ids From Import Receipt Source ndjson, Index Patterns Identified (wazuh-alerts-* / wazuh-archives-*), Unauth /api/status Correctly 401
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:31:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-61-dashboard-runtime-baseline.md`

---

## 1. Runtime environment discovery (live)

```
$ docker ps --format '{{.Names}}\t{{.Ports}}' | grep dashboard
multi-node-wazuh.dashboard-1   443/tcp, 127.0.0.1:443->5601/tcp

$ ss -ltnp | grep ':443 '
LISTEN 0 4096 127.0.0.1:443  0.0.0.0:*        ← loopback-bound host listener confirmed
```

Dashboard is reachable on the host at `https://127.0.0.1` (TLS terminating at the
OpenSearch Dashboards container). No LAN exposure of :443 — consistent with the
management-plane loopback model (phase40-85 §4).

## 2. Auth method (credentials by reference — no values herein)

- UI/API login: user `admin`, password = Wazuh API password, consumed at runtime from
  `/opt/wazuh-docker/multi-node/ops/creds.env` (`${WAZUH_WUI_PASSWORD}`); never
  written into any file or command history artifact.
- Unauth probe this run: `GET https://127.0.0.1/api/status` → **HTTP 401**
  `{"statusCode":401,"error":"Unauthorized","message":"Authentication required"}`
  — version banner retrieval requires auth as designed; anonymous banner claim
  therefore NOT asserted.

## 3. Saved-object inventory (8 ids, fixed at P40 import)

Source of truth: import receipt source file
`ops/evidence/p39-dashboards/w1-w2-windows-endpoints.ndjson`
(imported 8/8 into tenant **securitytenant=global**, phase40-62; ids deterministic `p39-*`).

| Type | Id | Title |
|------|----|-------|
| dashboard | p39-w1-windows-endpoints | W1 — Windows Endpoints: Connectivity, Freshness, Throttle |
| dashboard | p39-w2-windows-telemetry-quality | W2 — Windows EID Coverage & Telemetry Quality / Billing Elig |
| visualization | p39-w1-agent-status-metric | Windows Agents — Active Count |
| visualization | p39-w1-lastkeepalive-freshness | Last KeepAlive Freshness by Agent |
| visualization | p39-w1-throttle-events | Event Volume per Windows Agent (throttle indicator) |
| visualization | p39-w2-eid-top-table | Top Windows Eventchannel EIDs |
| visualization | p39-w2-telemetry-quality-metric | Telemetry Quality — Events vs Archives Ratio |
| visualization | p39-w2-billing-eligible-tagcloud | Billing-Eligible Windows Agents |

## 4. Index patterns backing panels

Panels query standard patterns only:

- `wazuh-alerts-*` — detection/alert stream (W2 EID table, quality ratio numerator)
- `wazuh-archives-*` — full event stream (throttle/volume, quality denominator)

Both patterns resolve against live indices today (52,959 alerts / 1,003,382 archive
events in last 24h, phase41-62).

## 5. Runtime visual rendering validation

PENDING login-based check — honest boundary: everything above is environment +
inventory fact; rendered-viewport verification requires an authenticated browser
session and remains open for the owner/operator pass.
