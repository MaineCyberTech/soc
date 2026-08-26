# Phase 43: Field Setting Verification

**Report ID:** phase43-06-field-c1-limit.md
**Phase:** 43
**Title:** Phase 43 Field Setting Verification — C1 Limit=2000
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T11:45:00Z
**Classification:** INTERNAL
**Status:** PENDING (awaiting 08.27 index)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-06-field-c1-limit.md`

---

## 1. Purpose

Verify the 08.27 archive index has `index.mapping.total_fields.limit=2000` and the intended ISM policy is attached.

---

## 2. Verification Command

```bash
curl -sk -u admin:[REDACTED-PW] "https://127.0.0.1:9200/wazuh-archives-4.x-2026.08.27/_settings?flat_settings=true&filter_path=*.settings.index.mapping.total_fields*,*.settings.index.plugins.index_state_management*"
```

---

## 3. Expected Output

```json
{
  "wazuh-archives-4.x-2026.08.27": {
    "settings": {
      "index": {
        "mapping": {
          "total_fields": {
            "limit": "2000"
          }
        },
        "plugins": {
          "index_state_management": {
            "policy_id": "wazuh-archives-14d"
          }
        }
      }
    }
  }
}
```

---

## 3. Pass Criteria

| Check | Pass Condition |
|-------|----------------|
| C1a | `index.mapping.total_fields.limit` = "2000" |
| C1b | `index.plugins.index_state_management.policy_id` = "wazuh-archives-14d" |
| C1b | No conflicting template override (priority < 320) |

---

## 4. Conflict Check

```bash
curl -sk -u admin:[REDACTED-PW] "https://127.0.0.1:9200/_index_template" | python3 -c "
import json,sys
d=json.load(sys.stdin)
for t in d.get('index_templates',[]):
    tpl=t['index_template']
    if any('wazuh-archives' in p for p in tpl.get('index_patterns',[])):
        print(f\"name={tpl.get('name')} priority={tpl.get('priority')} limit={tpl.get('template',{}).get('settings',{}).get('index',{}).get('mapping',{}).get('total_fields',{}).get('limit','N/A')}\")
"
```

**Expected**: Only `wazuh-archives-fieldlimit` (priority 320) matches and has limit=2000.

---

## 5. Status

**STATUS: PENDING** — Awaiting 08.27 index creation (~00:00:02Z tonight).