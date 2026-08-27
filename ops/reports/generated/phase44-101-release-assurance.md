# Phase 44: Release Assurance

**Report ID:** phase44-102-release-assurance
**Phase:** 44
**Title:** Phase 44 — Release Assurance (v1.3.0 + v1.3.1)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T23:55:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase44-101-release-assurance.md`

---

## 1. v1.3.0 Assurance

| Check | Status | Evidence |
|-------|--------|----------|
| Tag/Commit/Tree | VERIFIED | `c96dc5f` → `114324d...` |
| Asset Hash | BYTE-EXACT | `da72bde4...` |
| Image Pins | VERIFIED | Spot-check |
| Configs | DELTA-DOCUMENTED | P42 deltas (field fix, TLS, webhook, merged.mg, ISM, monitor, dashboards) |
| Rules/Workflows | CURRENT | 544 ET Open + 3 workflows |
| Reports/Catalogs | CURRENT | 392 rows |
| AGENTS Links | RESOLVE | AGENTS.md links resolve |
| Alerts Flowing | YES | 46 delivered today |
| Dashboards | 8 IMPORTED | 8/8 valid |
| Sensitive Gates | PASS | Triple CI green |

---

## 2. v1.3.1 Assurance

| Check | Status | Evidence |
|-------|--------|----------|
| Tag/Commit/Tree | VERIFIED | `c96dc5f` → `114324d...` |
| Tag Remote | VERIFIED | `git ls-remote origin refs/tags/v1.3.1` |
| Asset Hash | VERIFIED | `4e6c3712...` |
| Manifest | WRITTEN | `ops/releases/v1.3.1/MANIFEST.md` |
| Deltas | REGISTERED | D-1..D-12 (P41/P42 deltas) |
| Workflows | CURRENT | 3 workflows exported |
| Reports/Catalogs | CURRENT | 392 rows |
| AGENTS Links | RESOLVE | AGENTS.md links resolve |
| Sensitive Gates | PASS | Triple CI green (rerun) |

---

## 2. Post-Tag Deltas (v1.3.0 → v1.3.1)

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

## 3. Sensitive Gates (Re-Run)

| Gate | Command | Result |
|------|---------|--------|
| p38-report-ci | `bash ops/scripts/p38-report-ci.sh` | PASS (0 warnings) |
| p39-canonical-ci | `bash ops/scripts/p39-canonical-ci.sh` | PASS |
| p39-agents-ci | `bash ops/scripts/p39-agents-ci.sh` | PASS |

---

## 4. Verdict

**ASSURED-WITH-TABLED-DELTAS** — v1.3.0 custody closed; v1.3.1 on-box; publication pending token.