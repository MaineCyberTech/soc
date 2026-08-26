# Phase 42 ISM Wave Observation — PENDING-WINDOW

**Report ID:** phase42-62-ism-wave-observe
**Phase:** 42
**Title:** OBSERVE-42 — Status PENDING-WINDOW: Exact ETA Recomputed From Live Explain (Deletion Eligible 2026-08-29T21:00:44Z, ISM 5-Minute Job Interval ⇒ Realized Delete Within Minutes After); Ready-To-Run Command Block Staged, Hourly Post-ETA Recheck Cadence Defined, Error/Retry Watch Points Named, FORCE-DELETION PROHIBITION Restated
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T09:30:00Z
**Classification:** INTERNAL
**Status:** PENDING-WINDOW
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-62-ism-wave-observe.md`

---

## 1. Window math (recomputed from live explain, not from the plan doc)

- `index_creation_date` for wazuh-archives-4.x-2026.08.15 = **1786827644251 ms**
  = 2026-08-15T21:00:44.251Z.
- Policy transition `min_index_age=14d` ⇒ eligible at **2026-08-29T21:00:44.251Z**.
- Distance from this session's 09:10Z read: **3 d 11 h 50 m 44 s (~3.49 days)**.
  (The "~2.5 days" shorthand used in earlier planning notes under-counted; this
  exact figure supersedes it.)
- ISM job interval default is 5 minutes; the explain shows
  `attempt_transition_step` actively re-evaluated (`starting` state observed live at
  09:22Z), so realized deletion should land within minutes of eligibility.
- Second deletion (08.16) follows ~3 h later: created 2026-08-16T00:00:01.702Z ⇒
  due **2026-08-30T00:00:01.702Z**.

## 2. Ready-to-run observation block

```bash
OS='curl -sk -u admin:[REDACTED-PW] https://127.0.0.1:9200'
# A. Wave fired? (expect 08.15 absent, count 12→11)
$OS '/_cat/indices/wazuh-archives-*?v&h=index,health,status,docs.count,store.size,pri.store.size&s=index'
# B. Explain the leader before/after:
$OS '/_plugins/_ism/explain/wazuh-archives-4.x-2026.08.15?pretty'
# C. Diff vs baseline (phase42-63 method): compare against ops/evidence/p41-ism-baseline.json
# D. Disk relief realized:
df -h /dev/sda1; $OS /_cat/allocation?v
# E. Cluster health through the transition:
$OS '/_cluster/health?pretty'
```

## 3. Cadence

| When | Action |
|------|--------|
| Now → ETA | Hourly disk read (`df` + `_cat/allocation`) added to observe loop; single-digit-GB margin justifies it despite decider-off (phase42-61 §5) |
| ETA ±15 min | First check (§2 block A–E); expect index gone or explain showing delete-state progression |
| Post-ETA hourly | Recheck until deletion observed; then daily until day-7 relief accounting complete (phase42-65 table) |
| 08-30T00:00Z±15m | Second-deletion check (08.16) |

## 4. Error / retry watch points

In every explain read during the window, inspect:
- `retry_info.failed` and `consumed_retries` — policy allows ×3 retries with
  exponential backoff from 1 m on the delete action; nonzero values are the first
  signal of trouble.
- `step.step_status` — expect `condition_not_met` pre-window; post-window a move to
  the `delete` state; anything `failed` triggers escalation, NOT intervention.
- Cluster health must stay green through transitions; shards total drops by 2 when
  08.15 (1p+1r) leaves.

## 5. PROHIBITION (binding)

**No forced deletion — ever.** If the wave is late, if retries fail, if disk pressure
grows: agents and operators MUST NOT manually delete indices, MUST NOT weaken or
toggle watermarks/thresholds, and MUST NOT improvise past the approval gate for
manual ISM/index intervention (AGENTS.md MUST-NOT list + phase40-59 do-not-touch).
A late wave is an observation finding, not an action trigger.

## 6. Exit condition

This report flips from PENDING-WINDOW to COMPLETE when §2A shows the first real
policy-driven deletion (or when a dated deferral is owner-approved); either outcome
gets its own evidence file under `ops/evidence/`.
