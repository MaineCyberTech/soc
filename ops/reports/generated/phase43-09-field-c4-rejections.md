# Phase 43: Rejection Flatline Verification

**Report ID:** phase43-09-field-c4-rejections.md
**Phase:** 43
**Title:** Phase 43 Rejection Flatline Verification — C4 Rejection Flatline
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T12:10:00Z
**Classification:** INTERNAL
**Status:** PENDING
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-09-field-c4-rejections.md`

---

## 1. Purpose

Verify the 08.27 archive index has **zero** "Limit of total fields" rejection errors post-cutover.

---

## 1. Verification Command

```bash
docker logs multi-node-wazuh.master-1 --since 12h 2>&1 | grep -c "Limit of total fields"
```

---

## 2. Pass Criteria

| Check | Pass Condition |
|-------|----------------|
| C4 | Rejection count = 0 for 08.27 index window |

---

## 2. Context

| Period | Rejections | Notes |
|--------|------------|-------|
| 08.25 (pre-containment) | ~150/min | ~200k/day |
| 08.26 (legacy index) | 2,746 total (bursts at 07:02, 07:45) | Legacy mapping (limit=1000) |
| **08.27 (post-containment)** | **0 expected** | Template limit=2000 + stats removed |

---

## 3. Verification Command

```bash
# Last 12 hours (adjust window as needed)
docker logs multi-node-wazuh.master-1 --since 12h 2>&1 | grep -c "Limit of total fields"

# Specific to 08.27 index (if log format includes index name)
docker logs multi-node-wazuh.master-1 --since 12h 2>&1 | grep "wazuh-archives-4.x-2026.08.27" | grep -c "Limit of total fields"
```

---

## 4. Pass Criteria

| Check | Pass Condition |
|-------|----------------|
| C4 | Rejection count = 0 for 08.27 index since creation |

---

## 5. Status

**STATUS: PENDING** — Awaiting 08.27 index creation and sufficient time to verify zero rejections.