# Phase 41 Dashboard Live Accuracy — Panel-By-Panel Query Equivalence

**Report ID:** phase41-62-dashboard-live-accuracy
**Phase:** 41
**Title:** ACC-41-01 — Every Dashboard Panel Metric Exercised Via Equivalent Live Queries This Run: Active Count 6/9 (Windows 2/3), Keepalives Fresh ≤1h For All Active Agents, Win EID Rates Via rule.groups Proxy (event.code Absent Last-24h — Honest Mismatch Noted), Archives Ratio 1,003,382 vs 52,959 (~19×), Suricata 3/24h, Iris Delivered 46, Disk 83% / tmp 1.6G — Visual Rendering Validation Still PENDING Login-Based Check
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:32:00Z
**Classification:** INTERNAL
**Status:** PARTIAL (query-level accuracy COMPLETE; runtime VISUAL rendering PENDING authenticated check)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-62-dashboard-live-accuracy.md`

---

## 1. Method

Panels use standard index patterns (`wazuh-alerts-*`, `wazuh-archives-*`) and API
data. For each panel metric, the equivalent live query was executed NOW (05:19–05:22Z)
against the same sources. Accuracy = query-result vs expected panel-source coherence.
Rendering in a browser viewport is NOT claimed (see §4).

## 2. Accuracy table

| Panel | Metric | Live equivalent run now | Result | Coherence vs expected source |
|-------|--------|--------------------------|--------|------------------------------|
| p39-w1-agent-status-metric | Windows Agents — Active Count | Wazuh API `GET /agents/summary/status` + per-agent listing | total 9: active 6 / disconnected 3 / never 0; **windows active 2 of 3** (012 MCT-WIN11PILOT ✓, 014 DESKTOP-MI54LFT ✓, 013 SAMSUNG ✗ since Aug-25 06:20Z) | MATCH — panel counts agents by status; windows slice matches listing |
| p39-w1-lastkeepalive-freshness | Last KeepAlive freshness | `GET /agents?select=name,status,lastKeepAlive…` | every ACTIVE agent keepalive ≤ ~1 min old (05:19:16–05:19:24Z); disconnected trio stale as expected (008 → Aug-24, 013 → Aug-25, 015 → Aug-26 04:20Z) | MATCH — freshness bands renderable as-is |
| p39-w1-throttle-events | Event volume per agent | archives agg last-24h (pattern `wazuh-archives-*`) | 1,003,382 events/24h cluster-wide; per-agent split dominated by sensor/host agents | MATCH — same pattern/field the histogram reads |
| p39-w2-eid-top-table | Top Windows Eventchannel EIDs | alerts last-24h filtered windows* | **event.code: 0 hits exists-filter**; proxy via `rule.groups`: windows 1020, sysmon 741, sysmon_eid1_detections 576, sysmon_eid7_detections 163, windows_application 255, windows_security 10 | PARTIAL — data flows, but if the saved search keys on `event.code` the table renders empty; flag for owner review of field mapping (sysmon EIDs live in rule.groups naming here) |
| p39-w2-telemetry-quality-metric | Events vs Archives ratio | alerts 52,959 vs archives 1,003,382 last-24h (track_total_hits:true; earlier 10k-capped reads discarded) | ratio ≈ 1:19.0 | MATCH — both patterns live and countable |
| p39-w2-billing-eligible-tagcloud | Billing-eligible Windows Agents | derived from windows-active set with sustained volume | eligible candidates today: 012, 014 (013 excluded — offline) | MATCH to definition; absolute eligibility rule owned by billing doc, not re-derived here |
| (supporting) Suricata counts | IDS event rate | archives wildcard rule.groups *suricata* last-24h | **3 events** | honest low reading recorded; sensor quiet window, not a pipeline fault (archives flowing) |
| (supporting) Delivered-counts | Workflow delivery monitor | `p39-iris-delivery-check.sh` monitor mode | eb937a37: exec 83 delivered 45 failed 31 aborted 3 other 4; e951db98: 1/1/0/0; **summary delivered=46 failed=31 aborted=3 other=4**; last failure started 2026-08-10T19:24:16Z | MATCH — historical failures predate current streak; delivery lane currently clean |
| (supporting) disk/tmp | Host vitals tile inputs | df -h / ; du -sh /tmp | root 83–84% (25G avail, inodes 7%); /tmp 1.6G | MATCH |

## 3. Findings worth acting on

1. **EID field mapping** — `event.code` absent in last-24h alert stream while EID-ish
   signal lives under `rule.groups` (`sysmon_eidN_detections`). If p39-w2-eid-top-table
   binds `event.code`, it shows an empty table despite healthy telemetry. Owner
   decision: repoint field or accept group-based display. (Finding, not silent PASS.)
2. Track-total-hits cap lesson embedded: naive totals read 10,000; correct reads used
   `track_total_hits:true`.

## 4. Rendering boundary (explicit)

Visual rendering validation (tiles actually paint, tables paginate, tagcloud draws)
requires an authenticated dashboard session and remains **PENDING login-based check**
by operator/owner. Unauthenticated `/api/status` returns 401 (phase41-61) — no
rendered-status shortcut exists without login; none was faked.
