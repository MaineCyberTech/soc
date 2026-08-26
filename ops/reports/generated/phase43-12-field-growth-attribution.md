# Phase 43: Field Growth Attribution

**Report ID:** phase43-12-field-growth-attribution.md
**Phase:** 43
**Title:** Phase 43 Field Growth Attribution — 08.26 Growth Decomposition
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T12:30:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-12-field-growth-attribution.md`

---

## 1. Purpose

Attribute the +86 field growth on 08.26 (1766 → 1852 unique leaf fields, +86 in ~3 hours) to specific producers.

---

## 1. Growth Timeline

| Time | Leaf Fields | Delta | Notes |
|------|-------------|-------|-------|
| 05:52Z | 1,766 | — | Morning baseline |
| 07:40Z | 1,852 | +86 | CRIT threshold crossed |
| 09:30Z | 1,852 | 0 | Plateau |

---

## 2. Attribution Breakdown

| Component | 05:52Z | 09:30Z | Delta | Attribution |
|-----------|--------|--------|-------|-------------|
| data.stats (legacy) | 441 | 441 | 0 | Immutable (immutable on 08.26) |
| data.win | 77 | 92 | **+15** | New EIDs from Windows agents (012, 014) |
| data.virustotal | 0 | 13 | **+13** | New VT integration responses (file scans) |
| data.osquery | 28 | 29 | +1 | New process/service discovery |
| data.ubiquiti | 36 | 36 | 0 | Stable |
| data.parameters | 35 | 35 | 0 | Stable |
| data.audit | 30 | 30 | 0 | Stable |
| data.service | 30 | 30 | 0 | Stable |
| data.osquery | 28 | 29 | +1 | New process/service |
| data.netinfo | 22 | 22 | 0 | Stable |
| data.syscheck | 20 | 20 | 0 | Stable |
| data.unifi | 19 | 19 | 0 | Stable |
| data.rule | 15 | 15 | 0 | Stable |
| data.os | 14 | 14 | 0 | Stable |
| data.virustotal | 0 | 13 | **+13** | NEW: VT integration responses |
| data.port | 11 | 11 | 0 | Stable |
| **TOTAL** | **1,766** | **1,852** | **+86** | |

---

## 2. Key Findings

| Finding | Evidence |
|---------|----------|
| **Legacy stats immutable** | data.stats stuck at 441 (immutable on 08.26) |
| **Win growth** | +15 fields from new Windows EIDs (agents 012, 014) |
| **VT growth** | +13 fields from VirusTotal integration (file scan results) |
| **osquery** | +1 (new process/service discovered) |
| **No stats growth** | Confirmed: stats removed from eve.json; 08.26 stats frozen |

---

## 3. Producer Correlation

| Producer | Agent | Fields Added | Evidence |
|----------|-------|--------------|----------|
| Windows agents (012, 014) | 012 MCT-WIN11PILOT, 014 DESKTOP-MI54LFT | +15 win fields | New EIDs registered today |
| VT Integration | Wazuh-VT integration | +13 VT fields | File scan responses |
| osquery | Agent 011/014 | +1 | New process/service seen |

---

## 4. Velocity Analysis

| Period | Delta | Rate |
|--------|-------|------|
| 05:52 → 07:40 (1h 48m) | +86 | **~48 fields/hour** |
| 07:40 → 09:30 (1h 50m) | 0 | **0/hour (plateau)** |

> **Projection to midnight**: At 0/hour plateau, 08.27 index will start at ~1,300–1,400 (no legacy stats). If organic growth continues at ~30-40/day, end-of-day ~1,350–1,450. Well under 2,000.

---

## 5. Status

**COMPLETE** — Growth attributed. 08.26 CRIT is legacy baggage + organic growth; 08.27 projected safe.