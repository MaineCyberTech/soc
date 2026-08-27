# Phase 44: Field C3 Full-Stats Absent

**Report ID:** phase44-14-field-c3
**Phase:** 44
**Title:** Phase 44 — Field C3 Full-Stats Absent Verification
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T23:40:00Z
**Classification:** INTERNAL
**Status:** PENDING (awaiting 08.27 index)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase44-14-field-c3.md`

---

## 1. Condition C3

| Condition | Requirement |
|-----------|-------------|
| **C3** | Zero documents with `data.event_type: "stats"` in `wazuh-archives-4.x-2026.08.27` |

---

## 1. Verification Command

```bash
curl -sk -u admin:[REDACTED-PW] "https://127.0.0.1:9200/wazuh-archives-4.x-2026.08.27/_count?q=data.event_type:%22stats%22"
```

---

## 1. Expected Output (PASS)

```json
{
  "count": 0,
  "_shards": { "total": 1, "successful": 1, "skipped": 0, "failed": 0 }
}
```

---

## 2. Pass Criteria

| Check | Pass Condition |
|-------|----------------|
| C3 | `count` = 0 (no full-stats docs in 08.27 index) |

---

## 2. Contrast: 08.26 Index (Legacy)

```bash
curl -sk -u admin:[REDACTED-PW] "https://127.0.0.1:9200/wazuh-archives-4.x-2026.08.26/_count?q=data.event_type:%22stats%22"
```

**Expected**: > 0 (legacy stats documents from pre-containment era)

---

## 3. Status

**STATUS: PENDING** — Awaiting 08.27 index birth. Compact stats lane (`stats_compact`) active; full stats removed from eve.json.