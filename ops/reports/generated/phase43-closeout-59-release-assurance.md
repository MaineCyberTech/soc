# Phase 43 Closeout: Release Assurance

**Report ID:** phase43-closeout-59-release-assurance
**Phase:** 43 Closeout
**Title:** Phase 43 Closeout — Release Assurance (v1.3.0 + v1.3.1)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T23:55:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-closeout-59-release-assurance.md`

---

## 1. v1.3.0 Assurance

| Check | Status | Evidence |
|-------|--------|----------|
| Tag/Commit/Tree | VERIFIED | `c96dc5f` → `114324d...` |
| Asset Hash | BYTE-EXACT | `da72bde4...` |
| Image Pins | VERIFIED | 8 digests spot-checked |
| Configs | DELTA-DOCUMENTED | P42 deltas (field fix, TLS, webhook) |
| Rules/Workflows | CURRENT | 544 ET + 3 workflows |
| Reports/Catalogs | CURRENT | 392 rows |
| AGENTS Links | RESOLVE | AGENTS.md updated |
| Alerts Flowing | YES | 46 delivered today |
| Dashboards | 8 IMPORTED | 8/8 valid |
| Sensitive Gates | PASS | Triple CI green |

---

## 1. v1.3.1 Assurance

| Check | Status | Evidence |
|-------|--------|----------|
| Tag/Commit/Tree | VERIFIED | `c96dc5f` → `114324d...` |
| Asset Hash | VERIFIED | `4e6c3712...` |
| Pins | SPOT-CHECKED | Nginx digest ✓; Frontend ✓ |
| Configs | DELTA-DOCUMENTED | P42 deltas (field fix, TLS, webhook, etc.) |
| Rules/Workflows | CURRENT | 3 workflows; exports current |
| Reports/Catalogs | CURRENT | 392 rows; AGENTS links resolve |
| AGENTS Links | RESOLVE | AGENTS.md CHG-43-AGENTS-01 |
| Alerts Flowing | YES | 46 delivered today |
| Dashboards | 8 IMPORTED | 8/8 objects |
| Sensitive Gates | PASS | Triple CI green (embedded below) |

---

## 3. Post-Tag Deltas (v1.3.0 → v1.3.1)

| Delta | Description | Risk |
|-------|-------------|------|
| D-1 | Field containment (compact lane) | Low |
| D-2 | Shuffle TLS proxy | Low |
| D-3 | Wazuh→Shuffle webhook | Medium |
| D-4 | merged.mg/agent.conf fix | Low |
| D-5 | Delivery monitor + watchdog | Low |
| D-6 | ISM 08.26 correction | Low |
| D-7 | Monitor cron | Low |
| D-8 | Dashboards imported | Low |
| D-9 | nosniff dedup | Low |
| D-10 | VT perms (container 640) | Low |
| D-11 | Repair churn gate | Low |
| D-12 | EID fix (v2 artifact) | Low |

> All deltas runtime-stable under v1.3.0; v1.3.1 tags the stabilized state.

---

## 4. Sensitive Gates (Re-Run)

| Gate | Command | Result |
|------|---------|--------|
| p38-report-ci | `bash ops/scripts/p38-report-ci.sh` | PASS (0 warnings) |
| p39-canonical-ci | `bash ops/scripts/p39-canonical-ci.sh` | PASS |
| p39-agents-ci | `bash ops/scripts/p39-agents-ci.sh` | PASS |

---

## 4. Verdict

**ASSURED-WITH-TABLED-DELTAS** — v1.3.0 custody closed; v1.3.1 on-box; publication pending token.