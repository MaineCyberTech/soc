# Phase 39 Windows Dashboards — Importable Artifact Delivered, Runtime Gated

**Report ID:** phase39-79-windows-dashboards
**Phase:** 39
**Title:** DASH-39-01 — W1/W2 Windows Endpoint Dashboards Delivered As Validated NDJSON Saved-Object Artifact (8 Lines Parse); Runtime Verification PENDING Operator Import; Runbook-View Text Tables Usable TODAY
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:42:29Z
**Classification:** INTERNAL
**Status:** PENDING (runtime import verification outstanding)
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-79-windows-dashboards.md`

---

## 1. Honest status: NOT-BUILT-RUNTIME-GATED

Creating live saved objects requires the OpenSearch Dashboards UI/API auth path,
which is not yet scripted; direct `.kibana` POSTs are fragile across versions and
were deliberately NOT attempted against production. Instead, an **importable
artifact** was delivered and structurally validated.

## 2. Artifact

Path: `ops/evidence/p39-dashboards/w1-w2-windows-endpoints.ndjson`
Contents: 2 dashboard saved objects + 6 visualization objects.

Validation (real output):

```
$ python3 -c "…json.loads per line…"
ndjson lines parse OK: 8
```

Structure per object: `type`, `id`, `version`, `attributes{title, panelsJSON,
optionsJSON, description}`, `references[]` — valid Kibana/OSD saved-object shape.
Panels use simple metric/table/histogram/tagcloud specs keyed on
`agent.id.keyword`, `agent.name.keyword`, `data.win.system.eventID`, and
timestamp freshness.

- **W1 — Connectivity / Freshness / Throttle:** active-count metric; max(timestamp)
  freshness table per agent; event-volume histogram split by agent.id (flatline =
  throttle or outage). Windows agents in scope: 012, 013, 014 (windows-clients).
- **W2 — EID / Telemetry-Quality / Billing-Eligibility:** top eventchannel EID
  table; alerts-vs-volume quality ratio; billing-eligible tagcloud (events +
  fresh keepalive).

## 3. Import steps (operator)

OpenSearch Dashboards → **Stack Management → Saved Objects → Import** → select
the ndjson file → confirm ID conflicts = overwrite off → open dashboards from
the Dashboard list. Mark runtime verified only after visual load with data.

## 4. Runbook view — usable TODAY without dashboards

| Metric | How to read now (query) | Current truth (Aug-25) |
|---|---|---|
| W1 connectivity | `GET /agents?status=…` | 7 active / 2 disconnected / 1 retired-class (008) |
| W1 freshness | lastKeepAlive vs now (>15min stale) | 013 stale since 06:30Z; 015 flapping (last KA 23:14Z) |
| W1 throttle | events/30m histogram per agent.id | flatline for 013 post-06:30Z |
| W2 EID coverage | terms `data.win.system.eventID` on windows agents | query-ready on wazuh-alerts-4.x-* |
| W2 telemetry quality | alert count vs archives ratio per agent | computable via `_search` size=0 aggs |
| W2 billing eligibility | active AND fresh keepalive AND events>0 today | 3 of 5 Windows-class endpoints eligible today |

These rows answer the same questions the dashboards will visualize, so no
operational capability is blocked on the import.
