# Phase 40 Template Simulation

**Report ID:** phase40-05-template-simulation
**Phase:** 40
**Title:** Phase 40 Template Simulation — `_simulate_index` Resolution vs ACTUAL Index State (Simulation Validated by Reality)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T01:55:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Claims:** VERIFIED (MEASURED)
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-05-template-simulation.md`

---

## 1. Purpose

P39 validated the fix by simulation alone (nothing existed to check against). P40 runs
the same simulation POST-creation and diffs it against reality — the strongest form of
simulation evidence: agreement with an actually-materialized index.

## 2. Simulation Output (MEASURED, run this session)

```
$ curl -sk -u admin:[REDACTED] -X POST \
  "https://127.0.0.1:9200/_index_template/_simulate_index/wazuh-archives-4.x-2026.08.26?pretty"
{
  "template" : {
    "settings" : {
      "index" : {
        "mapping" : { "total_fields" : { "limit" : "2000" } },
        "plugins" : {
          "index_state_management" : { "policy_id" : "wazuh-archives-14d" }
        }
      }
    },
    "aliases" : { }
  },
  "overlapping" : [
    { "name" : "wazuh-main",                   "index_patterns" : ["wazuh-alerts-4.x-*", "wazuh-archives-4.x-*"] },
    { "name" : "wazuh",                        "index_patterns" : ["wazuh-alerts-4.x-*", "wazuh-archives-4.x-*"] },
    { "name" : "wazuh-archives-p19-retention", "index_patterns" : ["wazuh-archives-4.x-*"] }
  ]
}
```

(`fieldlimit` itself is the WINNER — its settings are what `template.settings` shows;
overlapping lists the losers.)

## 3. Competing Template Priorities (MEASURED)

```
GET _index_template/wazuh-archives-p19-retention → priority 310 (ISM policy only)
GET _index_template/wazuh-main                   → priority 300,
    settings: total_fields.limit=10000 AND plugins.index_state_management.policy_id=wazuh-retention
GET _template/wazuh (legacy)                     → order 0, total_fields.limit=10000 (+default_field list)
GET _index_template/wazuh-archives-fieldlimit    → priority 320, limit 2000 + ISM wazuh-archives-14d
```

Resolution arithmetic: 320 > 310 > 300 > legacy order 0 → fieldlimit must supply both
keys for any `wazuh-archives-4.x-*` index.

## 4. Simulation vs Reality Diff

| Key | Simulated | Actual on 08.26 (`_settings`) | Match |
|---|---|---|---|
| `index.mapping.total_fields.limit` | 2000 | `"2000"` | YES |
| `index.plugins.index_state_management.policy_id` | wazuh-archives-14d | `wazuh-archives-14d` (setting-level) | YES |
| aliases | `{}` | `{}` | YES |
| shards/replicas | (inherited defaults) | 1 / 1 DOCUMENT | consistent |

**The P39 simulation is now validated by a materialized index — no drift between
predicted and actual template composition.** Caveat carried forward: see phase40-06 §5
— the ISM RUNTIME attachment picked `wazuh-retention`, diverging from BOTH the setting
and the simulation at the plugin layer (not a template-resolution defect).

## 5. Verdict

**COMPLETE — PASS.** Simulation output and live index agree on every resolved key;
priority ordering proven both analytically (§3) and empirically (§4).
