# Phase 44: Field Growth Attribution

**Report ID:** phase44-15-field-growth-attribution
**Phase:** 44
**Title:** Phase 44 — Field Growth Attribution (08.26 Growth Decomposition)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T23:50:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase44-15-field-growth-attribution.md`

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
| data.virustotal | 0 | 13 | **+13** | NEW: VT integration responses |
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
| **VT growth** | +13 fields from VirusTotal integration responses |
| **Containment working** | Stats removed from eve.json; 08.27 will start clean |
| **Growth plateaued** | 0 delta from 07:40Z → 09:30Z |

---

## 3. Velocity Analysis

| Period | Delta | Rate |
|--------|-------|------|
| 05:52 → 07:40 (1h48m) | +86 | ~48 fields/hour |
| 07:40 → 09:30 (1h 50m) | 0 | 0/hour (plateau) |

> **Projection to midnight**: At 0/hour, 08.27 will start at ~1,300–1,350 leaves (well under 1,400 soft guardrail).

---

## 3. Status

**COMPLETE** — Growth attributed. 08.26 CRIT is legacy baggage; 08.27 projected safe.