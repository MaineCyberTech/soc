# Phase 44: v1.3.1 Cut Decision

**Report ID:** phase44-78-v131-cut-decision
**Phase:** 44
**Title:** Phase 44 — v1.3.1 Cut Decision
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T00:10:00Z
**Classification:** INTERNAL
**Status:** EXECUTED
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase44-78-v131-cut-decision.md`

---

## 1. Decision

**CUT EXECUTED** — v1.3.1 tagged and pushed.

---

## 1. Rationale

| Factor | Assessment |
|--------|------------|
| Deltas runtime-stable | All D-1..D-12 running stably on v1.3.0 |
| Packet lane blocker | Platform-side (Shuffle Tools); not config |
| Release cadence | ~Monthly; v1.3.0 → v1.3.1 on schedule |
| No breaking changes | All deltas backward-compatible |

---

## 2. Decision Record

| Field | Value |
|-------|-------|
| Decision | **CUT v1.3.1** |
| Decided By | Automation (Phase 43 mission) |
| Date | 2026-08-26 |
| Git Tag | `v1.3.1` (annotated) |
| Commit | `6579919` (Phase 42 HEAD) |
| Tree | `33d8443` (Phase 43 HEAD) |
| Push Status | **PUSHED** (`[new tag] v1.3.1 -> v1.3.1`) |

---

## 3. Artifacts

| Artifact | Location | SHA256 |
|----------|----------|--------|
| Tag | `v1.3.1` (annotated) | `71701dfd356549f1c5d2e13c9a24256afa3eac8b` |
| Commit | `6579919` | `c96dc5f` |
| Tree | `33d8443` | — |
| Asset | `ops/releases/v1.3.1/v1.3.1-from-tag.tar.gz` | `4e6c3712ba88f5ab925a2049d5d214fb55222a602c79738028ffee9a23ebf596` |
| Manifest | `ops/releases/v1.3.1/MANIFEST.md` | — |

---

## 3. Status

**EXECUTED** — Tag cut, pushed, asset built. Publication pending GH token.