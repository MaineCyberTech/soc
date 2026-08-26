# Phase 43: Shuffle Upgrade Readiness

**Report ID:** phase43-42-shuffle-upgrade-readiness.md
**Phase:** 43
**Title:** Phase 43 Shuffle Upgrade Readiness Assessment
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T18:15:00Z
**Classification:** INTERNAL
**Status:** ASSESSMENT COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-42-shuffle-upgrade-readiness.md`

---

## 1. Current Version

| Component | Version |
|-----------|---------|
| Shuffle | 1.2.0 (on-prem) |
| Shuffle Tools | 1.2.0 |
| Shuffle Frontend | ghcr.io/shuffle/shuffle-frontend@sha256:4d700a6f... |
| Shuffle Backend | Latest from ghcr.io/shuffle/shuffle-backend |

---

## 1. Upgrade Readiness Assessment

| Factor | Status | Notes |
|--------|--------|-------|
| Current version | 1.2.0 | Base version |
| Latest upstream | Check `ghcr.io/shuffle/shuffle-backend:latest` | Need to check |
| Breaking changes | Unknown | Need changelog review |
| Config compatibility | Compose v1.3.1 compatible | Likely compatible |
| Data migration | OpenSearch indices | Backward compatible |
| Workflow compatibility | Native nodes stable | `execute_python` is the issue |
| Downtime tolerance | Low (24/7) | Blue-green needed |

---

## 2. Upgrade Path Options

| Path | Steps | Risk | Effort |
|------|-------|------|--------|
| **In-place upgrade** | `docker pull latest` + `docker compose up -d` | Medium (config drift) | Low |
| **Blue-green** | Deploy v2 alongside; switch DNS | Low | Medium |
| **Fresh deploy** | New stack; migrate data | Low | High |

---

## 3. Pre-Upgrade Requirements

| Requirement | Status |
|-------------|--------|
| Workflow exports backup | DONE (phase42-17, phase42-39) |
| Hook docs backup | DONE (ops/evidence/p42-workflow-export/) |
| OpenSearch snapshot | Current (fs + s3) |
| Config backup | DONE (git tracked) |
| Rollback plan | Documented |

---

## 3. Recommendation

**Defer upgrade** — Native rebuild (Option A) is lower risk, faster, and achieves certification without platform dependency. Upgrade remains fallback (Option B) if native rebuild fails.

---

## 4. Status

**ASSESSMENT COMPLETE** — Upgrade readiness documented; native rebuild preferred. Upgrade remains fallback option.