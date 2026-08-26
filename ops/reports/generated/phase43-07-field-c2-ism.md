# Phase 43: ISM Policy Verification

**Report ID:** phase43-07-field-c2-ism.md
**Phase:** 43
**Title:** Phase 43 ISM Policy Verification — C2 ISM Assignment
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T11:50:00Z
**Classification:** INTERNAL
**Status:** PENDING
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-07-field-c2-ism.md`

---

## 1. Purpose

Verify the 08.27 archive index has ISM policy `wazuh-archives-14d` attached and active.

---

## 2. Verification Command

```bash
curl -sk -u admin:[REDACTED-PW] "https://127.0.0.1:9200/_plugins/_ism/explain/wazuh-archives-4.x-2026.08.27"
```

---

## 3. Expected Output

```json
{
  "wazuh-archives-4.x-2026.08.27": {
    "index.plugins.index_state_management.policy_id": "wazuh-archives-14d",
    "index.opendistro.index_state_management.policy_id": "wazuh-archives-14d",
    "policy_id": "wazuh-archives-14d",
    "state": { "name": "hot" },
    "info": { "message": "condition_not_met" }
  }
}
```

---

## 3. Pass Criteria

| Check | Pass Condition |
|-------|----------------|
| C2a | `policy_id` = "wazuh-archives-14d" |
| C2b | `state.name` = "hot" |
| C2c | `info.message` = "condition_not_met" (or "executing" if past 14d) |

---

## 4. Conflict Check

```bash
curl -sk -u admin:[REDACTED-PW] "https://127.0.0.1:9200/_index_template" | python3 -c "
import json,sys
d=json.load(sys.stdin)
for t in d.get('index_templates',[]):
    tpl=t['index_template']
    if 'wazuh-archives' in str(tpl.get('index_patterns',[])):
        print(f\"name={tpl.get('name')} priority={tpl.get('priority')} ISM={tpl.get('index_template',{}).get('settings',{}).get('index',{}).get('plugins',{}).get('index_state_management',{}).get('policy_id','N/A')}\")
"
```

**Expected**: Only `wazuh-archives-fieldlimit` (priority 320) carries ISM; no conflicting higher-priority template.

---

## 5. Status

**STATUS: PENDING** — Awaiting 08.27 index creation (~00:00:02Z tonight).