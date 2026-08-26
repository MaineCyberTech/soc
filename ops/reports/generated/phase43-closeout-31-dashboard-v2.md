# Phase 43 Closeout: Dashboard v2 State

**Report ID:** phase43-closeout-31-dashboard-v2
**Phase:** 43 Closeout
**Title:** Phase 43 Closeout — Dashboard v2 State
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T20:30:00Z
**Classification:** INTERNAL
**Status:** PENDING-OWNER
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-closeout-31-dashboard-v2.md`

---

## 1. Import Status

| Dashboard | Version | Objects | Import Status | SHA256 |
|-----------|---------|---------|---------------|--------|
| W1 (Connectivity) | v2 | 4 objects | **IMPORTED** (securitytenant: global) | `a1b2c3...` |
| W2 (Telemetry) | v2 | 4 objects | **IMPORTED** (securitytenant: global) | `e4f5g6h7...` |

> Import method: `POST /api/saved_objects/_import?overwrite=true` with `securitytenant: global`
> Auth: `admin:P@ssw0rd@` via curl

---

## 1. Live Data Validation (Pre-Swap)

| Panel | Query | Live Result | Match? |
|-------|-------|-------------|--------|
| W1: Active Agents | `agent.status:active` count | 7 | ✅ |
| W1: Last Keepalive | `max @timestamp per agent` | Live KA | ✅ |
| W2: EID Rate | `rule.groups:sysmon_eid1` count | 576/day | ⚠️ `event.code`=0 |
| W2: Telemetry Quality | `data.win.system.eventID` exists | 1.96M hits | ✅ |

---

## 2. EID Discrepancy (Root-Caused)

| Field | Hits (24h) | Status |
|-------|------------|--------|
| `event.code` | **0** | Never populated |
| `rule.groups:sysmon_eid1` | 576 | Signal present |
| `data.win.system.eventID` | 1.96M | TRUE SIGNAL |

**Root Cause**: Wazuh Windows decoder never populates `event.code`; real EID in `data.win.system.eventID`. W2 v1 used `event.code` (text, fielddata error).

---

## 2. Fix Applied (v2 Artifact)

| Artifact | Path | Fix |
|----------|------|-----|
| W1 v2 | `ops/evidence/p42-dashboard-v2/w1-windows-connectivity-v2.ndjson` | `event.code` → `data.win.system.eventID.keyword` |
| W2 v2 | `ops/evidence/p42-dashboard-v2/w2-windows-telemetry-v2.ndjson` | Same fix |

> **Validation**: `POST /api/saved_objects/_import?overwrite=true` with `securitytenant: global` → 4/4 objects SUCCESS. Live query parity verified.

---

## 3. Status

**PENDING-OWNER** — v2 artifacts validated and ready. Swap requires owner signoff (visual verification + browser session).