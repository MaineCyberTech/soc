# Phase 39 Field-Setting Proof

**Report ID:** phase39-23-field-setting-proof  
**Phase:** 39  
**Title:** Field-Limit Setting Inheritance Proof — Criteria, Conflict Flags, and Pre-Captured Evidence (Awaiting 2026.08.26 Creation)  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T23:02:00Z  
**Classification:** INTERNAL  
**Status:** PENDING  
**Authoritative:** true  
**Author:** opencode/ox-alpha  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-23-field-setting-proof.md`  
**Unblock Condition:** creation of `wazuh-archives-4.x-2026.08.26` (~00:00:02Z Aug-26)

---

## 1. Purpose

Defines the pass/fail criteria under which the setting-level half of the field-limit
fix is certified: the new index must demonstrably inherit `total_fields.limit=2000`
AND the carried ISM settings from `wazuh-archives-fieldlimit`, with no higher-priority
template overriding either key.

## 2. What CAN Be Verified Tonight — PRE-CAPTURED (MEASURED)

### 2.1 Template body correctness

Live GET (full body in phase39-21 §2): patterns `["wazuh-archives-4.x-*"]`,
priority **320**, `index.mapping.total_fields.limit="2000"`,
`index.plugins.index_state_management.policy_id="wazuh-archives-14d"`,
composed_of empty. No defects found; nothing to re-edit before midnight.

### 2.2 Simulated inheritance (OpenSearch's own resolution)

```
$ curl -s -k -u admin:P@ssw0rd@ -XPOST \
  "https://127.0.0.1:9200/_index_template/_simulate_index/wazuh-archives-4.x-2026.08.26"
{"template":{"settings":{"index":{"mapping":{"total_fields":{"limit":"2000"}},
"plugins":{"index_state_management":{"policy_id":"wazuh-archives-14d"}}}},"aliases":{}},
"overlapping":[{"name":"wazuh-main",...},{"name":"wazuh",...},
 {"name":"wazuh-archives-p19-retention","index_patterns":["wazuh-archives-4.x-*"]}]}
```

Simulation resolves both target keys to the intended values despite two competing
templates (300/legacy) — the precedence math is already machine-confirmed.

### 2.3 Negative control: pre-template index carries NO limit

The mechanism this proof relies on (creation-time inheritance) is demonstrated by the
active write target:

```
$ curl -s -k -u admin:P@ssw0rd@ "https://127.0.0.1:9200/wazuh-archives-4.x-2026.08.25/_settings?filter_path=**.total_fields*&pretty"
{ }
```

Empty ⇒ default 1000 ⇒ saturated mapping ⇒ live rejections ≈150/min (phase39-21 §6).
If inheritance did NOT work as simulated, tomorrow's settings would also read `{ }`
or an unexpected value — making this a true differential test.

## 3. Proof Criteria (post-roll)

| Gate | Check | PASS |
|---|---|---|
| S1 | `_settings?flat_settings=true` on 08.26 | `index.mapping.total_fields.limit` == `"2000"` |
| S2 | same response | `index.plugins.index_state_management.policy_id` == `"wazuh-archives-14d"` |
| S3 | ISM explain API | policy attached, no init failure/backup-missing error |
| S4 | simulate_index rerun | unchanged vs phase39-21 §4 (drift = template edited overnight → investigate first) |

S1 alone proves the headline fix; S2/S3 prove retention was not silently dropped by
template layering (the reason the P38 PUT carried ISM settings explicitly).

## 4. Conflicting-State Flags (FAIL signatures)

| Flag | Signature on 08.26 | Interpretation | Response |
|---|---|---|---|
| F1 | limit absent or `"1000"` | fieldlimit did not match/apply — pattern typo or template deleted | re-run §2 checks; inspect `_index_template` listing diff |
| F2 | limit `"10000"` + policy `wazuh-retention` | precedence flip toward wazuh-main (>320 or fieldlimit deleted) | priority-conflict playbook phase39-27 §5 |
| F3 | limit `"2000"` but policy missing/different | partial merge anomaly (unexpected third template) | dump all overlapping templates; reconcile before next roll |
| F4 | settings correct BUT rejections continue citing [2000] | fix applied; genuine growth beyond 2000/day | escalation path phase39-27 §6 (flat-object / drop-fields) |

F4 is not a setting-proof failure — it is a capacity outcome and routes to the
strategy review, not to template repair.

## 5. Explicit Non-Claims

Nothing here asserts the runtime state of 08.26; only template-layer facts are
certified tonight. The distinction matters because indices created before a template
change never retro-inherit it (proven by §2.3), so "template exists" can never be
substituted for "new index shows the value". Certification of S1–S4 happens in
phase40 follow-up using the phase39-22 script; this report flips to COMPLETE only
then.

## 6. Verdict

**PENDING.** All pre-capturable evidence is captured and consistent (§2). Runtime
gates S1–S4 unblocked solely by the 00:00:02Z Aug-26 roll.
