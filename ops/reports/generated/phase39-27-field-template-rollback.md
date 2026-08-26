# Phase 39 Field-Template Rollback

**Report ID:** phase39-27-field-template-rollback  
**Phase:** 39  
**Title:** Rollback and Alternatives — Safe Template Removal, Cardinality-Reduction Options, Priority-Conflict Playbook, and Strategy Escalation Triggers  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T23:10:00Z  
**Classification:** INTERNAL  
**Status:** COMPLETE  
**Authoritative:** true  
**Author:** opencode/ox-alpha  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-27-field-template-rollback.md`  
**Retention Class:** LONG

---

## 1. Purpose

Names the exit path BEFORE it is needed. Covers safe rollback of
`wazuh-archives-fieldlimit`, lower-cardinality alternatives if the limit approach is
outgrown, the priority-conflict playbook, and conditions that require a different
mapping strategy entirely.

## 2. Safe Rollback Steps

Key property: **composable templates affect only FUTURE index creation.** Existing
indices are immutable with respect to template changes; deleting the template neither
repairs nor damages any existing index.

```
# R1 remove the fix template (reverts future indices to pre-P38 inheritance posture)
curl -s -k -u admin:[REDACTED-PW] -XDELETE "https://127.0.0.1:9200/_index_template/wazuh-archives-fieldlimit"
# expect {"acknowledged":true}

# R2 verify removal + remaining overlap set unchanged
curl -s -k -u admin:[REDACTED-PW] "https://127.0.0.1:9200/_index_template" | \
  python3 -c "import json,sys; d=json.load(sys.stdin); [print(t['name'], t['index_template'].get('priority')) for t in d.get('index_templates',[]) if 'wazuh' in t['name']]"

# R3 confirm what future indices would now inherit (should show wazuh-main's 10000 winning,
#    NOT a return to default 1000 — see note)
curl -s -k -u admin:[REDACTED-PW] -XPOST "https://127.0.0.1:9200/_index_template/_simulate_index/wazuh-archives-4.x-2026.08.27"
```

Rollback-state note (measured basis): p19-retention (310) remains in place carrying
ISM policy wazuh-archives-14d, so retention survives rollback. Because wazuh-main
(300→ limit=10000) is present, rollback does NOT restore default-1000 behavior; it
restores the wazuh-main-wins composition. If the intent were "back to exactly tonight's
broken state", wazuh-main's archive-pattern coverage would also need review — out of
scope for a safety rollback; recorded so nobody is surprised by R3 output.

Existing indices under rejection (≤08.25) cannot be fixed by ANY template action;
options there are limited to close/delete per retention or reindex with an explicit
settings body (both destructive/expensive — not recommended; they age out naturally).

## 3. Lower-Cardinality Source Options (preventive)

| Option | Mechanism | Trade-off |
|---|---|---|
| Disable Suricata stats EVE events at sensor | `stats:` disabled in eve.json config (or suricata.yaml stats → no EVE stats records) | removes the observed 547-field burst class (phase39-26 §4); loses flow-counter visibility (usually redundant with elastiflow already present) |
| Drop at shipper instead | Filebeat drop_event/processor keyed on `event_type: stats` for archives dataset only | sensor untouched; manager CPU cost; reversible |
| Flatten `data.*` keys | ingest pipeline `convert`/script to collapse nested objects into dot-named scalars… NOTE: dot-named keys STILL count as fields; real flatten means JSON-stringify low-value branches into one field | large mapping win but kills per-field searchability of that branch |
| Drop unused branches via pipeline processor | `remove`/`drop_fields` on e.g. data.os.port.hardware duplicates | cheapest targeted reduction; requires branch-value review first |

Recommended sequencing if needed: sensor-side stats disable (option 1) first — highest
field yield per unit risk, directly targets the measured dominant branch.

## 4. Priority-Conflict Response Playbook

Trigger: any template matching `wazuh-archives-4.x-*` appears with priority >320
(e.g., a future bump of wazuh-main above 320 would silently rewrite BOTH limit
(2000→10000) and ISM policy (wazuh-archives-14d→wazuh-retention)).

1. **Detect**: weekly audit run includes `_index_template` listing diff vs this
   report's frozen inventory (fieldlimit 320 / p19-retention 310 / wazuh-main 300 /
   legacy wazuh order 0).
2. **Inspect**: fetch the newcomer's full body; simulate next-day index; diff composed
   settings against phase39-21 §4 baseline.
3. **Decide merge strategy**: (a) accept if its values are a superset/improvement AND
   ISM stays wazuh-archives-14d; (b) coexist — re-key conflicting settings onto our
   template and raise OUR priority.
4. **Bump priority**: PUT the same fieldlimit body with priority > offender's
   (e.g., 400), then re-simulate before the next midnight roll. Never leave two
   templates silently fighting across a roll boundary.

Standing hazard called out now: wazuh-main carries limit=10000 + wazuh-retention on
the same pattern family at priority 300 — one edit away from overriding both fix
keys. It is the FIRST suspect if phase39-23 gate S1 ever reads 10000.

## 5. Conditions Requiring a Different Mapping Strategy

| Trigger (sustained) | Response |
|---|---|
| True demand >2000 fields/day (08.26+ EOD counts, ≥3 consecutive days) — i.e., growth beyond new cap | move burst branches (data.stats first) to flat-object mapping, or add drop-fields ingest pipeline for low-value branches |
| HARD threshold (1800) breached twice consecutively (weekly audits §7 of phase39-26) | mandatory strategy review; consider selective disablement of EVE event types at sensor |
| Rejections resume citing [2000] while demand trend is flat (single spike day) | tolerate if <1hr and bounded; document as burst, no structural change |

Rationale: raising the limit again (e.g., 4000) treats symptom #N+1; the measured
branch structure (one branch class = 500+ fields) shows bursts scale faster than
comfortable limits. Structural reduction beats arithmetic headroom once triggers fire.

## 6. Verdict

**COMPLETE** (plan authored, unexecuted). Rollback verified non-destructive by design
(R1 affects future indices only); alternatives ranked; conflict playbook anchored to
frozen inventory from phase39-21 §3; escalation triggers quantified against measured
branch data.
