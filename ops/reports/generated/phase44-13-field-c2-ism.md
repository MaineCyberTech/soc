# Phase 44: Field C2 ISM Verification

**Report ID:** phase44-13-field-c2-ism
**Phase:** 44
**Title:** Phase 44 — Field C2 ISM Verification
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T23:35:00Z
**Classification:** INTERNAL
**Status:** PENDING (awaiting 08.27 index)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase44-13-field-c2-ism.md`

---

## 1. Condition C2

| Condition | Requirement |
|-----------|-------------|
| **C2** | ISM policy `wazuh-archives-14d` attached to `wazuh-archives-4.x-2026.08.27` |

---

## 1. Verification Command

```bash
curl -sk -u admin:[REDACTED-PW] "https://127.0.0.1:9200/_plugins/_ism/explain/wazuh-archives-4.x-2026.08.27"
```

---

## 2. Expected Output (PASS)

```json
{
  "wazuh-archives-4.x-2026.08.27": {
    "index.plugins.index_state_management.policy_id": "wazuh-archives-14d",
    "state": { "name": "hot" },
    "info": { "message": "condition_not_met" }
  }
}
```

---

## 2. Pass Criteria

| Check | Pass Condition |
|-------|----------------|
| C2a | `policy_id` = "wazuh-archives-14d" |
| C2b | `state.name` = "hot" |
| C2c | `info.message` = "condition_not_met" |

---

## 2. Status

**STATUS: PENDING** — Awaiting 08.27 index birth (~00:00:02Z Aug-27). ISM policy verified on template (simulate_index confirms carry-over).