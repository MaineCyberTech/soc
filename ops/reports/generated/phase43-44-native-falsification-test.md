# Phase 43: Native Falsification Test

**Report ID:** phase43-44-native-falsification-test.md
**Phase:** 43
**Title:** Phase 43 Native Falsification Test — Pre-Upgrade Probe
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T18:45:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-44-native-falsification-test.md`

---

## 1. Purpose

Before committing to a Shuffle upgrade, verify that the target version actually fixes the `execute_python` parameter injection and `if_else_routing` availability.

---

## 1. Test Plan (If Upgrade Proceeds)

| Test | Current (1.2.0) | Target (1.3+) | Pass Criteria |
|------|-----------------|---------------|---------------|
| `execute_python` input injection | FAIL (all UNDEF) | Should inject `data_in`/`input` | Input variable available in globals |
| `if_else_routing` availability | MISSING (404) | Present | Function executes |
| `repeat_back_to_me` input | Ignored (echoes name) | Should echo input | Input echoed |
| `$ref` interpolation in Tools | Literal strings | Should resolve refs | `check_datastore_contains` resolves `$ref` |

---

## 2. Test Workflow (Falsification Probe)

```json
{
  "name": "p43-upgrade-falsification",
  "actions": [
    {"label": "probe-exec-python", "app_name": "Shuffle Tools", "name": "execute_python", "parameters": [
      {"name": "call", "value": "execute_python"},
      {"name": "code", "value": "result = str(globals().keys())"}
    ]},
    {"label": "probe-ifelse", "app_name": "Shuffle Tools", "name": "if_else_routing", "parameters": [
      {"name": "call", "value": "if_else_routing"},
      {"name": "input", "value": "test"},
      {"name": "condition", "value": "equals"},
      {"name": "value", "value": "test"}
    ]}
  ],
  "triggers": [{"trigger_type": "WEBHOOK", "is_valid": true}]
}
```

---

## 3. Success Criteria

| Test | Pass Condition |
|------|----------------|
| `execute_python` globals | Contains `input`/`data_in`/`execution_input` variable |
| `if_else_routing` | Executes without "doesn't exist" error |
| `repeat_back_to_me` | Returns input value, not function name |
| `$ref` in Tools | Resolves to referenced action output |

---

## 3. Status

**READY TO EXECUTE** — Test workflow defined; will run IF upgrade proceeds (Option B chosen). Currently deferred per remediation decision (Option A preferred).