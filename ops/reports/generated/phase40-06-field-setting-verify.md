# Phase 40 Field Setting Verify

**Report ID:** phase40-06-field-setting-verify
**Phase:** 40
**Title:** Phase 40 Effective-Setting Proof — total_fields.limit=2000 Applied; Conflicting-Override Audit; ISM Attachment Deviation (ISM-40-01)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T01:56:00Z
**Classification:** INTERNAL
**Status:** PARTIAL (field-limit clause PASS; ISM attachment clause DEVIATION logged)
**Claims:** VERIFIED (MEASURED) for §2–§4; PARTIAL for §5
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-06-field-setting-verify.md`

---

## 1. Purpose

Gate S1–S4 / flip-condition G1 of phase39-28: prove what limit the live write target
actually enforces, and audit every template that could have overridden it.

## 2. Actual Index Settings (MEASURED)

```
$ curl -sk -u admin:[REDACTED] \
  "https://127.0.0.1:9200/wazuh-archives-4.x-2026.08.26/_settings?flat_settings=true&pretty"
{
  "wazuh-archives-4.x-2026.08.26" : {
    "settings" : {
      "index.creation_date" : "1787702402420",
      "index.mapping.total_fields.limit" : "2000",                        ← PROOF 1
      "index.number_of_replicas" : "1",
      "index.number_of_shards" : "1",
      "index.plugins.index_state_management.policy_id" : "wazuh-archives-14d",   ← setting-level
      "index.provided_name" : "<wazuh-archives-4.x-{2026.08.26||/d{yyyy.MM.dd|UTC}}>",
      "index.replication.type" : "DOCUMENT",
      "index.uuid" : "PYoV36MlRKO9UIYsgGNUBg",
      "index.version.created" : "136408327"
    }
  }
}
```

## 3. Behavioral Cross-Proof

Settings can lie only if nothing ever tests them. Two behavioral confirmations:

1. **Rejection signature flipped from `[1000]` to silence**: pre-roll errors cite
   `Limit of total fields [1000]`; post-roll zero rejections while ingest CONTINUED at
   higher volume and field count grew past the old 999 ceiling (phase40-07, -08).
2. **Wildcard query planner counts 1580 fields** on this index (field-expansion error,
   phase40-07 §5) — more fields mapped than the OLD ceiling allowed, with no mapping
   rejections anywhere post-cutover.

## 4. Conflicting-Override Audit — Priority Resolution Proven Empirically

Templates whose patterns also match `wazuh-archives-4.x-*`:

| Template | Priority/order | Defines limit? | Won? |
|---|---|---|---|
| `wazuh-archives-fieldlimit` | **320** | **2000** | **YES — applied** |
| `wazuh-archives-p19-retention` | 310 | (no) | contributed nothing conflicting |
| `wazuh-main` | 300 | **10000** + policy wazuh-retention | **NOT applied** |
| `wazuh` (legacy) | order 0 | 10000 | NOT applied |

The decisive observation: wazuh-main carries `total_fields.limit=10000`, yet the index
was born with **2000**. Had priority resolution failed in EITHER direction (highest
wins vs lowest wins), a 300-priority value could not have lost to 320 while a
310-priority template coexists — the empirical outcome matches only correct
highest-priority resolution. **PASS.**

## 5. DEVIATION — ISM-40-01: Runtime Policy Attachment Disagrees With Setting

Setting says `wazuh-archives-14d`. The ISM plugin attached something else:

```
$ GET _plugins/_ism/explain/wazuh-archives-4.x-2026.08.26 (excerpt)
  "policy_id" : "wazuh-retention",          ← 30-day delete policy
  "enabled" : true,
  state hot since epoch 1787703833515 = 2026-08-26T00:23:53Z
  transition attempt 00:29:05Z → condition_not_met (min_index_age not reached — normal)

Sibling comparison (_ism/explain/wazuh-archives-*):
  08.15…08.25 → policy_id wazuh-archives-14d   (all ten)
  08.26       → policy_id wazuh-retention       (ONLY outlier)
```

- **Impact (bounded):** this ONE archive will delete at ~30d instead of 14d — roughly
  +16 days × ~1 GB ≈ +1–1.5 GB disk vs plan. No security or data-loss exposure.
- **Suspected mechanism (unproven):** wazuh-main (priority 300) defines
  `plugins.index_state_management.policy_id=wazuh-retention`; the plugin's init sweep
  appears to have resolved its policy from a lower-priority overlapping template rather
  than the effective per-key winner. Cluster persistent settings show
  `plugins.index_state_management.metadata_migration.status=1` (background migration
  active) — candidate contributor.
- **Disposition:** G1's ISM clause is judged **DEVIATION**, not PASS. It does NOT gate
  the field-fix certification (phase40-13) because it is orthogonal to field limits;
  it is logged as defect ISM-40-01 with owner Infrastructure, unblock = root-cause +
  operator-approved `_ism/change_policy` decision (or documented acceptance).

## 6. Verdict

Field-limit objective: **PASS** (setting + behavior + override audit).
ISM assignment: **PARTIAL — deviation ISM-40-01 tracked.**
