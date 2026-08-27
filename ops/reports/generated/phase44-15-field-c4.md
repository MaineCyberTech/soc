# Phase 44: Field C4 Rejection Flatline

**Report ID:** phase44-15-field-c4
**Phase:** 44
**Title:** Phase 44 — Field C4 Rejection Flatline Verification
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T23:45:00Z
**Classification:** INTERNAL
**Status:** PENDING (awaiting 08.27 index)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase44-15-field-c4.md`

---

## 1. Condition C4

| Condition | Requirement |
|-----------|-------------|
| **C4** | Zero "Limit of total fields" rejection errors for `wazuh-archives-4.x-2026.08.27` post-cutover |

---

## 1. Verification Command

```bash
docker logs multi-node-wazuh.master-1 --since 12h 2>&1 | grep -c "Limit of total fields"
```

---

## 1. Pass Criteria

| Check | Pass Condition |
|-------|----------------|
| C4 | Rejection count = 0 for 08.27 index |

---

## 1. Context: 08.26 Legacy Rejections

| Period | Rejections | Source |
|--------|------------|--------|
| 2026-08-25 23:53–23:59 | ~150/min | Legacy 08.25 index (limit=1000) |
| 2026-08-26 00:00–00:01 | 3 | Cutover transition |
| 2026-08-26 07:02–07:45 | 2,746 total | 08.26 index (syscollector/vuln-detector) |
| 2026-08-26 post-07:45 | **0** | Flatline confirmed |

> **Key**: 08.26 index has immutable limit=1000. Rejections only from legacy docs. 08.27 will have limit=2000.

---

## 2. Status

**STATUS: PENDING** — Awaiting 08.27 index birth. Current rejections=0 for post-cutover window.