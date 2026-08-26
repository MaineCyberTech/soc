# Phase 40 Dashboard Data Validation

**Report ID:** phase40-63-dashboard-data-validation
**Phase:** 40
**Title:** Panel-Metric ↔ Live-API Query Equivalence Table — All Five Metric Families Proven Available (Agents Active/Freshness, Win EIDs, Throttle Volume, Suricata, Delivery); Runtime Rendering PENDING Visual Pass
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:29:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (data plane) / PENDING (runtime render pass)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-63-dashboard-data-validation.md`

---

## 1. Method

For each W1/W2 panel metric, define the exact indexer API query that produces
the number the panel would render, RUN it live (02:18–02:20Z), and record the
value. A panel is *data-proven* when its query returns a well-formed non-error
result; *render-proven* only after a human views it (PENDING, post-import).

## 2. Validation table — all queries executed

| Panel metric | Equivalent API query | Live result |
|---|---|---|
| W1: Agents Active Count | `_search` wazuh-monitoring-2026.35w, aggs status terms | `active=1164 docs, disconnected=447, pending=1` |
| W1: Last KeepAlive Freshness | sort lastKeepAlive desc, latest docs | `012 MCT-WIN11PILOT active 2026-08-26T02:14:57+00:00`, `016 mct-packet-sensor …02:14:57Z`, `006 docker-host …02:14:56Z` ⇒ sub-minute freshness |
| W1: Windows agents present | terms id ∈ {012,013,014} week index | `win_docs_week=567`; per agent 012=189, 013=189, 014=189 (perfectly even ⇒ no throttle skew) |
| W1: Event volume/throttle per agent | archives count agent.id=012 last 24h | `count=4261` (agent 012) |
| W2: Top Windows EIDs | wazuh-alerts-* win.eventID terms agg last 24h | total `907` events; EID 1=387, EID 7=158, EID 1001=148, EID 16384=118, EID 5061=46 |
| W2: Telemetry quality (events vs archives ratio) | alerts count vs archives count same window | 907 alerts vs 133,148 archive docs (24 h) — computable ratio |
| Suricata packet-capture counts (context panel) | wazuh-alerts rule.groups=suricata 24h | `count=10` (low but non-zero; sensor 016 active/fresh) |
| Routing/delivery counts (ops strip) | delivery monitor summary | `delivered=40 failed=31 aborted=3 other=4` (phase40-68 run output) |

Negative control: EID 4688 query returned `count=0` — field-filtered queries
correctly yield empty sets rather than errors, so empty-state panels will
render their zero-state rather than break.

Field-name notes captured for maintenance: monitoring uses camelCase
`lastKeepAlive` (not snake_case); alert event id field is
`data.win.system.eventID`.

## 3. Verdict

**Data availability: PROVEN for every panel family** — each dashboard metric
maps to a working query returning real values today.
**Runtime panel-rendering validation: PENDING** the interactive login + visual
pass now that import succeeded (phase40-62 §3); scheduled as the next SOC
console session action. No data-plane blocker remains.
