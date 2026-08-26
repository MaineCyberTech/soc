# Phase 43: Full-Stats Condition Verification

**Report ID:** phase43-08-field-c3-fullstats.md
**Phase:** 43
**Title:** Phase 43 Full-Stats Condition Verification — C3 Zero Full-Stats Docs
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T12:00:00Z
**Classification:** INTERNAL
**Status:** PENDING
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-08-field-c3-fullstats.md`

---

## 1. Purpose

Verify the 08.27 archive index has **zero** documents with `data.event_type: "stats"` (the old full Suricata stats that caused field explosion).

---

## 1. Verification Command

```bash
curl -sk -u admin:[REDACTED-PW] "https://127.0.0.1:9200/wazuh-archives-4.x-2026.08.27/_count?q=data.event_type:%22stats%22"
```

---

## 2. Expected Output

```json
{
  "count": 0,
  "_shards": { "total": 1, "successful": 1, "skipped": 0, "failed": 0 }
}
```

---

## 3. Pass Criteria

| Check | Pass Condition |
|-------|----------------|
| C3 | `count` = 0 (zero full-stats documents in 08.27 index) |

---

## 3. Contrast with 08.26 Index

```bash
curl -sk -u admin:[REDACTED-PW] "https://127.0.0.1:9200/wazuh-archives-4.x-2026.08.26/_count?q=data.event_type:%22stats%22"
```

**Expected**: >0 (legacy stats documents from pre-containment era)

---

## 4. Status

**STATUS: PENDING** — Awaiting 08.27 index creation (~00:00:02Z tonight).