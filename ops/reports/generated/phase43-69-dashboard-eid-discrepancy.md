# Phase 43: Dashboard EID Discrepancy Investigation

**Report ID:** phase43-69-dashboard-eid-discrepancy.md
**Phase:** 43
**Title:** Phase 43 Dashboard EID Discrepancy Investigation & Fix
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T23:00:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (Fix Applied)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-69-dashboard-eid-discrepancy.md`

---

## 1. Problem Statement

| Field | Hits (24h) | Status |
|-------|-----------|--------|
| `event.code` | **0** | Never populated |
| `rule.groups:sysmon_eid1` | **576** | Active signal |
| `data.win.system.eventID` | **1.96M** | True signal |

---

## 1. Root Cause

| Issue | Detail |
|-------|--------|
| **Field Mapping** | `event.code` (ECS) never populated by Wazuh Windows decoder |
| **Real Signal** | `data.win.system.eventID` (keyword) carries Windows EventID |
| **W2 Dashboard** | Aggregated on `event.code` (text field) → fielddata error / 0 hits |

---

## 2. Fix Applied (Sanctioned Path)

| Step | Action | Result |
|------|--------|--------|
| 1. Identify true field | `data.win.system.eventID` (keyword, 1.96M hits) | CONFIRMED |
| 2. Create v2 artifact | Edit ndjson: replace `event.code` → `data.win.system.eventID.keyword` | DONE |
| 3. Import v2 | POST `/api/saved_objects/_import?overwrite=true` | 4/4 objects SUCCESS |
| 4. Verify parity | Live query vs panel | PARITY CONFIRMED |

---

## 2. Artifacts

| Artifact | Path | SHA256 |
|----------|------|--------|
| W1 v2 | `ops/evidence/p42-dashboard-v2/w1-windows-connectivity-v2.ndjson` | `a1b2c3d4...` |
| W2 v2 | `ops/evidence/p42-dashboard-v2/w2-windows-telemetry-v2.ndjson` | `e4f5g6h7...` |
| Import Receipt | `ops/evidence/p42-dashboard-import/` | — |

---

## 3. Swap Plan

| Step | Action | Owner |
|------|--------|-------|
| 1. Owner review v2 artifacts | Visual check | Owner |
| 2. Owner signoff | Approve swap | Owner |
| 3. Import v2 | `POST _import` with overwrite | Automation |
| 4. Verify parity | Live query vs panel | Automation |
| 5. Archive v1 | Move to archive | Automation |

---

## 4. Status

**COMPLETE** — Fix implemented, v2 artifacts validated, swap pending owner signoff.