# Phase 43: v1.3.1 Assurance

**Report ID:** phase43-80-v131-assurance.md
**Phase:** 43
**Title:** Phase 43 v1.3.1 Release Assurance
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T00:20:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-80-v131-assurance.md`

---

## 1. Assurance Statement

**REL-ASR-43-01: ASSURED-ONBOX-PUBLICATION-PENDING**

---

## 1. Verification Checklist

| Check | Method | Result |
|-------|--------|--------|
| Tag ↔ Commit | `git rev-parse v1.3.1` = `6579919` | ✅ |
| Commit ↔ Tree | `git rev-parse v1.3.1^{tree}` = `114324d...` | ✅ |
| Tag Remote | `git ls-remote origin refs/tags/v1.3.1` | ✅ |
| Asset Hash | `sha256sum v1.3.1-from-tag.tar.gz` | ✅ `4e6c3712...` |
| Manifest | `cat MANIFEST.md` | ✅ |
| Delta Coverage | D-1..D-12 in manifest | ✅ |
| Triple CI | p38/p39-canonical/p39-agents | **3× PASS** (09:58Z) |

---

## 2. Delta Register (v1.3.0 → v1.3.1)

| Delta | Description | Risk |
|-------|-------------|------|
| D-1 | Field containment (stats removal + compact lane) | Low |
| D-2 | Shuffle TLS proxy + certs | Low |
| D-3 | Wazuh→Shuffle webhook (both nodes) | Medium |
| D-4 | merged.mg/windows-bak perms | Low |
| D-5 | Delivery monitor + watchdog | Low |
| D-6 | ISM 08.26 policy correction | Low |
| D-7 | Delivery monitor cron | Low |
| D-8 | Dashboards imported (8) | Low |
| D-9 | nosniff dedup | Low |
| D-10 | VT perms (container 640) | Low |
| D-11 | Repair churn gate | Low |
| D-12 | EID fix (v2 artifact) | Low |

> All deltas runtime-stable under v1.3.0; v1.3.1 tags the stabilized state.

---

## 3. Verdict

**ASSURED-ONBOX-PUBLICATION-PENDING** — On-box custody complete; GitHub publication pending token.

---

## 4. Status

**COMPLETE** — v1.3.1 assured on-box; publication pending GH token.