# Phase 40 Dashboard Artifact Inventory

**Report ID:** phase40-61-dashboard-artifact-inventory
**Phase:** 40
**Title:** W1/W2 Windows-Endpoints NDJSON Saved-Object Artifact — sha256, Object Parse (8 Objects: 2 Dashboards + 6 Visualizations), Import Prerequisites, Version Compatibility
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:27:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-61-dashboard-artifact-inventory.md`

---

## 1. Artifact identity

```
Path:   /opt/mct-security-stack/ops/evidence/p39-dashboards/w1-w2-windows-endpoints.ndjson
sha256: 71283319b2d9594d06d7a1b7892b62d333e064c211c9555f8155fa185e0957a7
Format: JSON-lines (validates as JSON lines — every line parsed OK)
Origin: Phase 39 DASH-39-01 build (see source reports below)
```

## 2. Object parse — ids / types / titles (REAL parse output)

```
1 p39-w1-windows-endpoints          | dashboard    | W1 — Windows Endpoints: Connectivity, Freshness, Throttle
2 p39-w2-windows-telemetry-quality  | dashboard    | W2 — Windows EID Coverage & Telemetry Quality / Billing Eligibility
3 p39-w1-agent-status-metric        | visualization| Windows Agents — Active Count
4 p39-w1-lastkeepalive-freshness    | visualization| Last KeepAlive Freshness by Agent
5 p39-w1-throttle-events            | visualization| Event Volume per Windows Agent (throttle indicator)
6 p39-w2-eid-top-table              | visualization| Top Windows Eventchannel EIDs
7 p39-w2-telemetry-quality-metric   | visualization| Telemetry Quality — Events vs Archives Ratio
8 p39-w2-billing-eligible-tagcloud  | visualization| Billing-Eligible Windows Agents
```

8 objects total: 2 dashboards (W1, W2) + 6 visualizations. Stable explicit IDs
(`p39-*`) make import idempotent under `?overwrite=true` and make rollback a
deterministic delete-by-id list.

## 3. Source report references

- DASH-39-01 design/build reports (phase39 dashboard series)
- Panel metric definitions mirrored in phase40-63 validation table
- Description field embedded in W1 object: "Phase 39 DASH-39-01 … Windows
  agents: 012,013,014 (windows-clients group)."

## 4. Import prerequisites — verified live

| Prereq | Status | Evidence |
|---|---|---|
| Dashboard service reachable | PASS | container `multi-node-wazuh.dashboard-1`, port map **127.0.0.1:443→5601/tcp** (`docker ps`); `ss -tlnp` shows LISTEN 127.0.0.1:443; `curl -sk https://127.0.0.1:443/` → HTTP 302 (login redirect = alive) |
| Import endpoint | present | `POST /api/saved_objects/_import` responded (see phase40-62) |
| Auth requirement | YES | Basic auth required; admin credentials used from stack `.env` convention |
| Tenant header caveat | NOTE | Header must be `securitytenant: global` (or omitted); `securitytenant: private` FAILS for the admin user — see phase40-62 blocker analysis |
| xsrf header | required | `-H 'osd-xsrf: true'` |

## 5. Version compatibility notes

Artifact was authored against this cluster's own OpenSearch Dashboards
(export/import round-trip within same version family) — no cross-version
migration expected. `type` fields are standard OSD saved-object types;
references between visualizations and dashboards use stable `p39-*` ids so
re-import order is irrelevant. If the stack upgrades OSD major versions
later, re-export rather than replaying this file.
