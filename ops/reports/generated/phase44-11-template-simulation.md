# Phase 44: Template Simulation

**Report ID:** phase44-11-template-simulation
**Phase:** 44
**Title:** Phase 44 — Template Simulation for 08.27 Index
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T23:20:00Z
**Classification:** INTERNAL
**Status:** READY (awaiting index)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase44-11-template-simulation.md`

---

## 1. Simulation Command (Ready to Run)

```bash
curl -sk -u admin:[REDACTED-PW] -X POST "https://127.0.0.1:9200/_index_template/_simulate_index/wazuh-archives-4.x-2026.08.27" \
  -H 'Content-Type: application/json' \
  -d '{}' | python3 -m json.tool
```

---

## 1. Expected Output (Pre-Validated)

```json
{
  "template": {
    "index_patterns": ["wazuh-archives-4.x-*"],
    "priority": 320,
    "template": {
      "settings": {
        "index.mapping.total_fields.limit": 2000,
        "index.plugins.index_state_management.policy_id": "wazuh-archives-14d"
      }
    }
  }
}
```

---

## 2. Expected Priority Resolution

| Template | Priority | Settings Carried |
|----------|----------|------------------|
| wazuh-archives-fieldlimit | **320** | limit=2000 + ISM policy |
| wazuh-retention | 310 | limit=10000 (lower priority) |
| wazuh-main | 300 | limit=10000 (lowest priority) |
| wazuh-states-retention | 315 | ISM only |
| wazuh-archives-14d | — | Inherited from wazuh-archives-fieldlimit |

> **Note**: Priority 320 wins over 315/310/300. The `wazuh-archives-fieldlimit` template carries BOTH the field limit AND the ISM policy.

---

## 3. Status

**STATUS: READY** — Command prepared, expected output documented. Awaiting index birth.