# Phase 40 ISM Index Diff & ISM-40-01 Correction

**Report ID:** phase40-56-ism-index-diff
**Phase:** 40
**Title:** Index Diff vs P39 Baseline + Anomaly ISM-40-01 (08.26 Attached `wazuh-retention` 30d Instead of `wazuh-archives-14d`) — Root-Cause Hypothesis, Impact Bound, CORRECTED via remove→add
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:22:00Z
**Classification:** INTERNAL
**Status:** COMPLETE — **ISM-40-01 CORRECTED**
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-56-ism-index-diff.md`

---

## 1. Diff methodology

1. Pull current `_cat/indices/wazuh-archives-*?h=index&s=index`.
2. Compare against P39 baseline inventory (phase39 series: expected members
   08.15…08.25, no 08.26).
3. Classify each delta as ADDED / DELETED / ANOMALY; anomalies get an
   explain-API interrogation (`show_policy=true`) plus policy-body comparison.

## 2. Result — PARTIAL-NOW diff (run 02:18Z)

Current list (12): `08.15, 08.16, 08.17, 08.18, 08.19, 08.20, 08.21, 08.22,
08.23, 08.24, 08.25, 08.26`.

| Class | Index | Evidence |
|---|---|---|
| ADDED | wazuh-archives-4.x-**2026.08.26** | Not in P39 baseline; created 2026-08-26T00:00:02Z; 128,567 docs / 125.2 MB at capture |
| DELETED | none | Expected — first wave ETA 2026-08-29T21:00:44Z still pending |

## 3. ANOMALY ISM-40-01 — wrong policy on 08.26

### 3.1 Observed (pre-fix explain, REAL OUTPUT abridged)

```
GET _plugins/_ism/explain/wazuh-archives-4.x-2026.08.26?show_policy=true
"policy_id":"wazuh-retention",          ← WRONG (30d)
"policy_seq_no":0,"policy_primary_term":1,
"state":{"name":"hot","start_time":1787703833515},
"step":{"step_status":"condition_not_met"},
"policy":{"policy_id":"wazuh-retention","description":
 "Wazuh retention: delete archives/alerts/monitoring/statistics after 30 days", ...}
```

Settings/template of record say `wazuh-archives-14d`; every sibling archive
index (08.15–08.25) carries it. 08.26 alone carried `wazuh-retention`.

### 3.2 Policy bodies compared

```
GET _plugins/_ism/policies/wazuh-retention      → hot --(min_index_age:30d)--> delete{}
GET _plugins/_ism/policies/wazuh-archives-14d   → hot --(min_index_age:14d)--> delete{}   (Phase 19 approved)
```

Both single-transition policies differ only in the age gate (30d vs 14d).

### 3.3 Hypothesized cause

At the creation instant (00:00:02Z) two candidate policy sources existed:
the `wazuh-retention` catch-all (older, seq_no 0/term 1) and the
`wazuh-archives-14d` template mapping. Most probable mechanisms:

1. **Initial-stale-cache**: the ISM background worker had a cached
   policy-template resolution from before the archives template update and
   bound the first new index to the stale answer;
2. **Policy-ID precedence at creation instant**: where both a generic
   `ism_template` match and an explicit setting exist, plugin resolution order
   picked the lower-version (`wazuh-retention`) entry for this one rollover.
Not reproducible without a controlled rollover test; flagged for one in the
next maintenance window (rollover 08.27 must be re-checked with §3.1 command).

### 3.4 Bounded impact if uncorrected

+16 days retention on one index ≈ its full size held ~16 extra days:
125 MB now, growing to the typical 0.1–3.8 GB/day envelope ⇒ bounded impact
**≈ +1–1.5 GB** of avoidable footprint over the window. Non-safety,
non-compliance impact (no data lost either way; both policies eventually
delete).

### 3.5 Corrective action EXECUTED (option b — remove→add)

Plain `_ism/add` is rejected when a policy exists, so the documented
remove→add sequence was used:

```
POST _plugins/_ism/remove/wazuh-archives-4.x-2026.08.26
→ {"updated_indices":1,"failures":false,"failed_indices":[]}

POST _plugins/_ism/add/wazuh-archives-4.x-2026.08.26  {"policy_id":"wazuh-archives-14d"}
→ {"updated_indices":1,"failures":false,"failed_indices":[]}
```

### 3.6 Post-fix re-explain — REAL OUTPUT (abridged)

```
GET _plugins/_ism/explain/wazuh-archives-4.x-2026.08.26?show_policy=true
"policy_id":"wazuh-archives-14d",
"enabled":true,
"policy":{"policy_id":"wazuh-archives-14d","description":
 "Archives retention: 14d hot then delete (Phase 19 approved plan)", ...}
```

Index re-enrolled under the approved policy; state machine will rebuild its
hot-state timer on next evaluation cycle. Corrected deletion horizon for
08.26: created 2026-08-26T00:00:02Z + 14d = 2026-09-09T00:00:02Z
(uncorrected would have been 2026-09-25T00:00:02Z).

## 4. Verdict

Diff clean otherwise (one ADDED, zero DELETED). **ISM-40-01 marked CORRECTED**
with API-level proof; residual action = verify 08.27 rollover inherits
`wazuh-archives-14d` natively (owner: MCT SOC automation).
