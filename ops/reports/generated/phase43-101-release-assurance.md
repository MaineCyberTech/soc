# Phase 43: Release Assurance

**Report ID:** phase43-101-release-assurance.md
**Phase:** 43
**Title:** Phase 43 Release Assurance (v1.3.0 + v1.3.1)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T23:55:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-101-release-assurance.md`

---

## 1. v1.3.0 Assurance

| Check | Status | Evidence |
|-------|--------|----------|
| Tag/Commit/Tree | VERIFIED | `c96dc5f` → `114324d...` |
| Asset Hash | BYTE-EXACT | `da72bde4...` |
| Image Pins | VERIFIED | 8 digests |
| Configs | DRIFT-CHECKED | P42 deltas only |
| Ruleset | 544 ET Open | Verified |
| Workflow Artifacts | EXPORTED | 3 workflows + hooks |
| Reports/Catalogs | CURRENT | 393 rows |
| Alerts Flowing | YES | 46 delivered today |
| Dashboards | 8 IMPORTED | 8/8 valid |
| Sensitive Gates | PASS | Triple CI green |

---

## 2. v1.3.1 Assurance

| Check | Status | Evidence |
|-------|--------|----------|
| Tag | PUSHED | `git ls-remote` ✅ |
| Asset | ON-BOX | `4e6c3712...` |
| Manifest | WRITTEN | `ops/releases/v1.3.1/MANIFEST.md` |
| Deltas | REGISTERED | D-1..D-12 |
| Release Page | PENDING | GH Token Required |

---

## 3. Post-Tag Deltas (v1.3.0 → v1.3.1)

| Delta | Description | Risk |
|-------|-------------|------|
| D-1 | Field Containment (compact lane) | Low |
| D-2 | Shuffle TLS Proxy | Low |
| D-3 | Wazuh→Shuffle Webhook | Medium |
| D-4 | merged.mg/agent.conf perms | Low |
| D-5 | Delivery Monitor + Watchdog | Low |
| D-6 | ISM 08.26 Correction | Low |
| D-7 | Monitor Cron | Low |
| D-8 | Dashboards Imported | Low |
| D-9 | nosniff Dedup | Low |
| D-10 | VT Perms (Container 640) | Low |
| D-11 | Repair Churn Gate | Low |
| D-12 | EID Fix (v2 Artifact) | Low |

> All deltas runtime-stable; v1.3.1 candidates for v1.3.1.

---

## 4. Sensitive Gates

| Gate | Command | Result |
|------|---------|--------|
| p38-report-ci | `bash ops/scripts/p38-report-ci.sh` | PASS (0 warnings) |
| p39-canonical-ci | `bash ops/scripts/p39-canonical-ci.sh` | PASS |
| p39-agents-ci | `bash ops/scripts/p39-agents-ci.sh` | PASS |
| Secret Scan | `grep -r` patterns | 0 hits |

---

## 5. Verdict

**ASSURED-WITH-TABLED-DELTAS** — v1.3.0 custody closed; v1.3.1 on-box; publication pending token.