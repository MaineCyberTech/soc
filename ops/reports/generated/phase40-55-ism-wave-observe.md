# Phase 40 ISM Wave Observe Plan

**Report ID:** phase40-55-ism-wave-observe
**Phase:** 40
**Title:** Deletion Wave Observation — Status PENDING-WINDOW (ETA 2026-08-29 > Today); Ready-to-Run Command Block, Error Watch, Force-Deletion Prohibition
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:21:00Z
**Classification:** INTERNAL
**Status:** PENDING-WINDOW
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-55-ism-wave-observe.md`

---

## 1. Statement

The first ISM deletion wave is **not due today**. Explain API shows
`step_status:"condition_not_met"` for the oldest index
(`wazuh-archives-4.x-2026.08.15`, created 2026-08-15T21:00:44Z, 14d policy).
ETA = **2026-08-29T21:00:44Z** — approximately 3.78 days after this report's
timestamp. This report defines the observation procedure; it does not claim a
result.

## 2. Ready-to-run command block (execute on/after 2026-08-29T21:05Z)

### 2.1 Before-state capture (any time before ETA)

```bash
OS="curl -sk -u admin:'P@ssw0rd@' https://127.0.0.1:9200"
# Full pre-wave list + sizes (save output)
$OS '/_cat/indices/wazuh-archives-*?v&h=index,docs.count,store.size&s=index' \
  | tee /tmp/opencode/ism-before.txt
# Per-index transition state for the expected victims
for D in 15 16 17; do
  $OS "/_plugins/_ism/explain/wazuh-archives-4.x-2026.08.$D?show_policy=true" \
    | python3 -c 'import json,sys;d=list(json.load(sys.stdin).values())[0];\
print(d["index"],d["state"]["name"],d.get("step",{}).get("step_status"))'
done
```

Expected before-state: all three `hot / condition_not_met`.

### 2.2 After-window diff (≥ 2026-08-29T21:10Z)

```bash
$OS '/_cat/indices/wazuh-archives-*?v&h=index,docs.count,store.size&s=index' \
  | tee /tmp/opencode/ism-after.txt
diff /tmp/opencode/ism-before.txt /tmp/opencode/ism-after.txt
# Expect: lines for 08.15 REMOVED (deleted); nothing else changed.
# Confirm managed count drop:
$OS '/_plugins/_ism/stats/managedIndices' | python3 -m json.tool | grep -c wazuh-archives
```

Pass criterion: `08.15` absent from `_cat/indices`, no red/yellow cluster
health change, no new ISM failures (see 2.3), disk freed ≈ 0.9–1.8 GB.

## 3. Error/retry watch during the window

Poll once per hour across Aug-29 20:00Z → Aug-30 02:00Z:

```bash
watch -n 3600 "$OS '/_plugins/_ism/explain/wazuh-archives-*' | grep -o '\"step_status\":\"[a-z_]*\"' | sort | uniq -c"
```

Escalation triggers (any ⇒ open incident, do NOT intervene manually):

| Signal | Meaning | Action |
|---|---|---|
| `"failed":true` or `consumed_retries > 0` on 08.15 | Delete action retrying (backoff 1m→exp, max 3) | Capture full explain JSON; wait one poll cycle |
| Step stuck ≠ `attempt_transition_step` for > 2 h past ETA | ISM worker stall | Check `_plugins/_ism/stats`; restart indexer nodes one at a time (container-level only) |
| Index still present 24 h past ETA with `condition_met` never logged | Scheduler miss | Re-explain; escalate with evidence |

## 4. Force-deletion prohibition

**Manual deletion of any `wazuh-archives-*` or `wazuh-alerts-*` index by
operator action (`DELETE /<index>`) is PROHIBITED outside the approved ISM
lane.** Rationale: manual deletes bypass ISM bookkeeping, invalidate the
retention certification chain (phase40-60), and destroy the controlled
before/after evidence this wave is meant to produce. If ISM fails, fix the
mechanism; never substitute an operator delete. Exception requires written
approval referencing this report.

## 5. Verdict

PENDING-WINDOW. Flip to OBSERVED-PASS when §2.2 diff shows the 08.15 removal;
flip to FAILED if §3 escalation triggers fire. Result will be recorded as an
amendment here and reflected in phase40-60 certification sub-verdicts.
