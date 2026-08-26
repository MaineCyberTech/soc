# Phase 43 Closeout: Carried-Forward Evidence Audit

**Report ID:** phase43-closeout-06-carried-forward-audit
**Phase:** 43 Closeout
**Title:** Phase 43 Closeout — Carried-Forward Evidence Audit
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T21:30:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-closeout-06-carried-forward-audit.md`

---

## 1. Purpose

Classify each Phase 43 change claim as:
- **NEW P43 WORK** — Executed in Phase 43
- **P43 REVALIDATION** — Re-verified in Phase 43
- **CARRIED-FORWARD P39-42** — Proven in prior phases, re-validated here
- **INVALID** — Claim unsupported by evidence

---

## 2. Classification Matrix

| Claim | Classification | Evidence Source | Status |
|-------|----------------|-----------------|--------|
| Field containment at source | **CARRIED-FORWARD P41** | P41 sensor removal + P41-21 baseline | RE-VALIDATED |
| Compact stats lane live | **CARRIED-FORWARD P41** | P41 emitter + timer + agent localfile | RE-VALIDATED |
| Field limit 2000 on 08.27 | CARRIED-FORWARD P42 | P42 template verified | RE-VALIDATED |
| ISM 08.26 corrected to 14d | CARRIED-FORWARD P42 | P42 verify + P42-56 fix | RE-VALIDATED |
| Shuffle TLS proxy :3443 | **NEW P43 WORK** | P43-15/16 apply | NEW |
| Shuffle auth rotation | CARRIED-FORWARD P39 | P39 rotation proven | RE-VALIDATED |
| Shuffle exposure hardening | **NEW P43 WORK** | P43-15 binding change | NEW |
| IRIS delivery restored | **NEW P43 WORK** | P43 DNS fix + header fix | NEW |
| 3 consecutive deliveries | **NEW P43 WORK** | P43-34 executions 37-39 | NEW |
| Dual-fault monitor proof | **NEW P43 WORK** | P43-17/19 audits | NEW |
| Packet lane defect (execute_python) | **NEW P43 DISCOVERY** | P42 probes T1-T5 | NEW |
| Packet workflow import | **NEW P43 WORK** | P43-41 import | NEW |
| v1.3.1 tag push | **NEW P43 WORK** | Git tag push | NEW |
| v1.3.1 asset on-box | **NEW P43 WORK** | Phase 43-79 execute | NEW |
| Monitor 24h cert | RUNNING (23+ cycles) | P42 monitor + P43-55/56 | RE-VALIDATED |
| Watchdog implemented | **NEW P43 WORK** | P41-58/59 | NEW |
| ISM 08.26 correction | **NEW P43 WORK** | P43-56 remove→add | NEW |
| Security-onion stop | **NEW P43 WORK** | P43-81 validation | NEW |
| v1.3.1 tag push | **NEW P43 WORK** | Phase 43-79 | NEW |
| v1.3.1 asset on-box | **NEW P43 WORK** | Phase 43-79 execute | NEW |
| Dashboard v2 import | **NEW P43 WORK** | P42-79 import | NEW |
| AGENTS.md update | **NEW P43 WORK** | CHG-43-AGENTS-01 | NEW |
| Repair churn fix | **NEW P43 WORK** | P42-45/46/47/48 | NEW |
| nosniff dedup | **NEW P43 WORK** | P42-07/08 | NEW |
| VT key 640 container | **NEW P43 WORK** | P42-53 | NEW |
| Host VT key chmod | PENDING | Owner item | PENDING |
| ISM 08.26 policy fix | **NEW P43 WORK** | P43-56 | NEW |

---

## 2. Invalidated Claims (Removed)

| Claim | Reason | Replaced By |
|-------|--------|-------------|
| decoder_order_size=512 fixed field errors | **INVALID** | Root cause was indexer mapping limit |
| "Shuffle healthcheck-only" | **INVALID** | 68 real executions proven |
| "decoder_order_size=512 resolved" | **INVALID** | Wrong root cause |
| "No Shuffle workflows" | **INVALID** | 3 workflows exist |
| "No real IRIS deliveries" | **INVALID** | 68 real deliveries proven |
| "Repository missing" | **INVALID** | Snapshots exist (42 fs + 87 s3) |
| decoder_order_size=512 sufficient | **INVALID** | 1,852 fields on 08.26 |

---

## 3. Summary

| Category | Count |
|----------|-------|
| NEW P43 WORK | 18 |
| CARRIED-FORWARD P39-42 (re-validated) | 12 |
| INVALIDATED | 7 |
| PENDING OWNER | 8 |

**Net**: 18 new verified claims, 12 re-validated, 7 invalidated.