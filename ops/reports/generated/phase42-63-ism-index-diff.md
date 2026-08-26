# Phase 42 ISM Index Diff — Methodology + Current State vs P41 Baseline

**Report ID:** phase42-63-ism-index-diff
**Phase:** 42
**Title:** DIFF-42 — Methodology Staged And First Run Executed: 12/12 Index Names Identical To p41 Baseline, Zero Deletions (Expected Pre-Wave), Single Live Delta = 08.26 Growth +221,612 Docs / +136.9MB pri Since 05:21Z Capture — All Older Indices Byte-Frozen As Expected
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T09:30:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (pre-wave diff executed; method reusable post-wave)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-63-ism-index-diff.md`

---

## 1. Method (staged for every future run)

1. Anchor: immutable baseline `ops/evidence/p41-ism-baseline.json`
   (`captured_at_utc: 2026-08-26T05:21:14Z`, 12 candidates in wave order).
2. Fresh read:
   `curl -sk -u admin:[REDACTED-PW] 'https://127.0.0.1:9200/_cat/indices/wazuh-archives-*?h=index,docs.count,pri.store.size&s=index'`
3. Set-diff on names → ADDED / REMOVED lists.
4. Per-name numeric delta for survivors (closed days must be byte-frozen; only the
   live day may grow).
5. Record deletions explicitly (expected ZERO until the wave fires).

## 2. Current diff (fresh read 09:07Z vs baseline 05:21Z)

**ADDED: none. REMOVED: none (zero deletions — expected pre-wave).**

| Index | docs @baseline | docs @09:07Z | Δdocs | pri @baseline | pri @now |
|---|---|---|---|---|---|
| 2026.08.15 | 3,007,251 | 3,007,251 | 0 | 932.4mb | 932.4mb |
| 2026.08.16 | 2,150,542 | 2,150,542 | 0 | 649.9mb | 649.9mb |
| 2026.08.17 | 2,633,464 | 2,633,464 | 0 | 1.2gb | 1.2gb |
| 2026.08.18 | 2,397,160 | 2,397,160 | 0 | 1gb | 1gb |
| 2026.08.19 | 2,519,199 | 2,519,199 | 0 | 1.9gb | 1.9gb |
| 2026.08.20 | 1,486,141 | 1,486,141 | 0 | 622.4mb | 622.4mb |
| 2026.08.21 | 1,423,025 | 1,423,025 | 0 | 627.4mb | 627.4mb |
| 2026.08.22 | 599,196 | 599,196 | 0 | 357.2mb | 357.2mb |
| 2026.08.23 | 170,521 | 170,521 | 0 | 49.1mb | 49.1mb |
| 2026.08.24 | 248,458 | 248,458 | 0 | 69.8mb | 69.8mb |
| 2026.08.25 | 882,772 | 882,772 | 0 | 284.8mb | 284.8mb |
| **2026.08.26 (live)** | 318,128 | 539,740 | **+221,612** | 155.8mb | **292.7mb (+136.9mb)** |

Growth rate implied: ~137 MB pri in ~3 h 46 m ≈ 35 MB/h during business hours,
consistent with the 0.5–1 GB/day planning band.

## 3. Post-wave reuse

When the wave fires (phase42-62), rerun §1 and expect: REMOVED = [08.15], then
[08.16] next midnight+; every removal must match a snapshot-covered index and a
corresponding drop in `_cat/allocation` disk.indices. Any name disappearing WITHOUT
a matching ISM explain transition is an anomaly requiring escalation (never a
manual-deletion trigger).
