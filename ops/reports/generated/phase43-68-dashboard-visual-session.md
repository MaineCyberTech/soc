# Phase 43: Dashboard Visual Session

**Report ID:** phase43-68-dashboard-visual-session.md
**Phase:** 43
**Title:** Phase 43 Dashboard Visual Session — Browser Validation
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T23:45:00Z
**Classification:** INTERNAL
**Status:** PENDING-BROWSER
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-68-dashboard-visual-session.md`

---

## 1. Purpose

Validate imported dashboards (W1/W2) via browser session — visual rendering, interactivity, data accuracy.

---

## 1. Session Kit (Prepared)

| Item | Detail |
|------|--------|
| URL | `https://127.0.0.1:443` (or `https://192.168.222.149:443` via proxy) |
| Auth | `admin` / `P@ssw0rd@` (OpenSearch Dashboards) |
| Dashboards | W1 (Windows Connectivity), W2 (Windows Telemetry) |
| Checklist | See below |

---

## 2. Visual Session Checklist

| Check | W1 (Connectivity) | W2 (Telemetry) |
|-------|-------------------|----------------|
| Loads without error | [ ] | [ ] |
| Time picker works | [ ] | [ ] |
| Refresh (auto/manual) | [ ] | [ ] |
| Filters apply | [ ] | [ ] |
| Panels render data | [ ] | [ ] |
| No "No data" / errors | [ ] | [ ] |
| Legends/tooltips | [ ] | [ ] |
| Drill-downs work | [ ] | [ ] |
| Mobile viewport | [ ] | [ ] |
| Dark/light mode | [ ] | [ ] |

---

## 3. Data Accuracy Spot-Checks

| Panel | Expected Query | Live Query | Match? |
|-------|----------------|------------|--------|
| Active Agents | `agent.status:active` count | API `/agents` count | [ ] |
| Last Keepalive | Max `@timestamp` per agent | API `last_keepalive` | [ ] |
| Alert Volume | `wazuh-alerts-*` count (24h) | `_count` API | [ ] |
| EID Rate | `rule.groups:sysmon_eid1` count | `_count` API | [ ] |
| Packet Lane | `data.event_type:stats_compact` | `_count` API | [ ] |

---

## 3. Status

**PENDING-BROWSER** — Requires human browser session. Session kit prepared; checklist ready.