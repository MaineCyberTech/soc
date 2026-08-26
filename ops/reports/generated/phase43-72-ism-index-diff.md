# Phase 43: ISM Index Diff

**Report ID:** phase43-72-ism-index-diff.md
**Phase:** 43
**Title:** Phase 43 ISM Index Diff — Pre/Post Wave Comparison
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T22:45:00Z
**Classification:** INTERNAL
**Status:** PENDING (Post-Wave)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-72-ism-index-diff.md`

---

## 1. Purpose

Compare pre-wave and post-wave index inventory to identify deleted/retained indices and anomalies.

---

## 1. Pre-Wave Baseline (Captured Pre-Wave)

| Index | Created | Size | Policy | State |
|-------|---------|------|--------|-------|
| wazuh-archives-4.x-2026.08.15 | 2026-08-15T00:00:02Z | 69.8 MB | wazuh-archives-14d | hot |
| wazuh-archives-4.x-2026.08.16 | 2026-08-16T00:00:02Z | 284.8 MB | wazuh-archives-14d | hot |
| wazuh-archives-4.x-2026.08.17 | ... | ... | ... | ... |
| ... | ... | ... | ... | ... |
| wazuh-archives-4.x-2026.08.28 | ... | ... | ... | ... |

*To be captured at T-1h pre-wave*

---

## 2. Post-Wave Diff (Post-Wave)

| Change | Index | Details |
|--------|-------|---------|
| DELETED | wazuh-archives-4.x-2026.08.15 | Expected (14d policy) |
| RETAINED | wazuh-archives-4.x-2026.08.16 | Next candidate |
| ADDED | wazuh-archives-4.x-2026.08.29 | New daily index |
| ANOMALIES | (none expected) | — |

---

## 2. Status

**PENDING** — Post-wave diff to be generated after Aug-29 wave.