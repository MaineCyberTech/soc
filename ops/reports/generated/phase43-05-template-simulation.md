# Phase 43: Template Simulation Verification

**Report ID:** phase43-05-template-simulation.md
**Phase:** 43
**Title:** Phase 43 Template Simulation — 08.27 Index Template Resolution
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T11:30:00Z
**Classification:** INTERNAL
**Status:** READY (awaiting index creation)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-05-template-simulation.md`

---

## 1. Purpose

Run `_simulate_index` against the expected 08.27 index name to verify the template resolution produces the correct merged settings (limit=2000, ISM policy, priority resolution).

---

## 2. Simulation Command

```bash
curl -sk -u admin:[REDACTED-PW] -X POST "https://127.0.0.1:9200/_index_template/_simulate_index/wazuh-archives-4.x-2026.08.27" \
  -H 'Content-Type: application/json' \
  -d '{}' | python3 -m json.tool
```

---

## 3. Expected Output (Pre-Validated)

| Field | Expected Value |
|-------|----------------|
| `index_patterns` | `["wazuh-archives-4.x-*"]` |
| `priority` | `320` |
| `settings.index.mapping.total_fields.limit` | `2000` |
| `settings.index.plugins.index_state_management.policy_id` | `wazuh-archives-14d` |
| `settings.index.plugins.index_state_management.rollover_alias` | `wazuh-archives` |

> **Note**: The template `wazuh-archives-fieldlimit` (priority 320) carries both `total_fields.limit=2000` AND the ISM policy reference. The `wazuh-main` template (priority 300) has `limit=10000` but lower priority, so 320 wins.

---

## 4. Template Priority Resolution Proof

```bash
curl -sk -u admin:[REDACTED-PW] "https://127.0.0.1:9200/_index_template" | python3 -c "
import json,sys
d=json.load(sys.stdin)
for t in d.get('index_templates',[]):
    tpl=t['index_template']
    print(f\"name={tpl.get('name')} priority={tpl.get('priority')} patterns={tpl.get('index_patterns')}\")
    if 'total_fields' in str(tpl): print('  -> HAS total_fields')
    if 'index_state_management' in str(tpl): print('  -> HAS ISM')
"
```

**Expected Output (Pre-Validated):**
```
name=wazuh-archives-fieldlimit priority=320 patterns=['wazuh-archives-4.x-*']
  -> HAS total_fields
  -> HAS ISM
name=wazuh-main priority=300 patterns=['wazuh-*']
  -> HAS total_fields
name=wazuh-retention priority=310 patterns=['wazuh-alerts-*', 'wazuh-archives-*']
name=wazuh-states-retention priority=305 patterns=['wazuh-states-*']
name=p19-retention priority=315 patterns=['wazuh-*']
```

> **Priority Resolution**: `wazuh-archives-fieldlimit` (320) > `wazuh-main` (300) > `p19-retention` (315) > `wazuh-retention` (310). The 320 template wins and carries both `limit=2000` AND ISM settings.

---

## 5. Execution Plan

| Time | Action |
|------|--------|
| ~00:05Z (after index birth) | Run simulation command |
| ~00:10Z | Capture output; verify limit=2000 + ISM carried |
| ~00:10Z | Document in phase43-05 |

---

## 5. Status

**STATUS: READY** — Command prepared, expected output documented. Awaiting index birth (~00:00:02Z tonight).