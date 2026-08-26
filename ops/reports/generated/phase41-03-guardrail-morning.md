# Phase 41 Guardrail Morning Reading

**Report ID:** phase41-03-guardrail-morning
**Phase:** 41
**Title:** Phase 41 Morning Guardrail — 1706/WARN Reading Interpreted Correctly After Rejection False-Alarm Resolution
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T04:55:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-03-guardrail-morning.md`

---

## 1. Purpose

Interpret the morning guardrail state honestly: the script says WARN, the naive log
pull said "rejections are back". Both signals needed reconciliation before any
containment design work, because they point in opposite directions (WARN = growth
pressure near budget; rejections = hard ceiling already breached). They cannot both be
true on the same index. They weren't.

## 2. The Reading (MEASURED)

```
$ ops/scripts/p40-field-growth-check.sh            (morning samples, P40 lineage)
p40-field-growth index=wazuh-archives-4.x-2026.08.26 leaf_fields=1706 limit=2000 soft=1400 hard=1800 verdict=WARN growth_per_day=0.0 branches[data:1637 rule:27 GeoLocation:8 agent:6 decoder:6 predecoder:6]
```

State TSV at arc start:

```
2026-08-26T01:44:18Z	1604
2026-08-26T02:43:38Z	1706
2026-08-26T03:05:17Z	1706
2026-08-26T03:38:34Z	1706
```

Two facts jump out:

1. **WARN is real but stale-shaped**: 1706 ≥ soft 1400 because P40's early-day burst
   (1580→1604 within H+2h) blew through the soft threshold before anyone could blink.
   The budget consumed is 85% of 2000 — genuinely uncomfortable, hence WARN stands.
2. **growth_per_day=0.0**: two consecutive samples saw ZERO new leaves. Growth had
   stopped. The WARN reflects position, not velocity.

## 3. Rejection False Alarm — Adjudication

The apparent rejection recurrence (phase41-01 §3–4) resolves entirely as pre-cutover
log residue:

| Check | Result |
|---|---|
| Bucketed histogram wazuh1.indexer-1 | ALL 8107 lines in 2026-08-24T23:52–23:59 (previous index's death throes) |
| Bucketed histogram wazuh2.indexer-1 | 5896 in 2026-08-25T23:53–23:59 + final 3 at 00:00:00.413/.414/.422Z |
| Any rejection after 00:00:01.431Z (P40-certified last) | **ZERO** across master + all workers, through arc end |
| Limit string in rejected writes | `[1000]` — old-index default era, not our 2000 template |

Conclusion: **no regression**. The morning `--since 6h` figure of ~8640 was the union
of two day-old storms bleeding into a sliding window. Lesson recorded for runbooks:
on these containers, rejection counts without timestamp bucketing are noise.

## 4. Why Fields Kept Growing Past Midnight Anyway (context)

The plateau did not exist at birth: 1580 leaves existed by H+1.6h because EVERY event
class that would appear all day appeared early (dynamic mapping maps a leaf on first
appearance). The stats lane front-loaded most of it — Suricata emits its full counter
set in each stats event, so all ~441 unique stat leaves mapped within the first hours
(phase41-06 §4). By 02:43 the day's vocabulary was complete; nothing new arrived until
containment changed the vocabulary itself (phase41-15).

## 5. Verdict Table

| Signal | Naive reading | Corrected reading | Disposition |
|---|---|---|---|
| leaf_fields=1706 | "approaching crisis" | 85% budget, but velocity 0 — plateau | Contain source anyway (P41 Arc B) |
| verdict=WARN | alarm | correct per policy; stays until steady-state < 1400 | Keep; re-eval post-08.27 |
| growth_per_day=0.0 | "fixed?" | plateau, not fix — source still emitting | Containment proceeds |
| 8640 rejections / 6h | "regression!" | pre-cutover residue, zero fresh | Close as false alarm |

## 6. Threshold Policy Context (unchanged by P41)

| Parameter | Value | Origin | P41 action |
|---|---|---|---|
| total_fields.limit | 2000 | P39 template `wazuh-archives-fieldlimit` (prio 320) | untouched ✓ |
| Soft WARN | 1400 | P39/P40 guardrail design | untouched ✓ |
| Hard CRIT | 1800 | P39/P40 guardrail design | untouched ✓ |
| Script exit codes | 0/1/2/3 = OK/WARN/CRIT/error | phase40-11 | reused as-is |

Position at morning reading: 1706 = **85.3%** of limit, above WARN by 306 leaves,
below CRIT by 94. With velocity zero, position alone does not demand emergency
action — but it leaves no room for another stats-sized family, which is precisely the
argument for source elimination over threshold relief.

## 7. False-Alarm Runbook Lesson (recorded)

Pattern to institutionalize for indexer log triage:

1. NEVER trust un-bucketed grep counts on long-lived containers; log buffers outlive
   the incident window.
2. Always re-pull with `docker logs --timestamps`, bucket to the minute, and compare
   bucket edges against the known cutover epoch (00:00:02Z index creation).
3. The `[1000]` vs `[2000]` limit string inside a rejection line identifies WHICH
   template era produced it — [1000] lines are definitionally pre-fix residue.
4. Canonical last-rejection reference stays 00:00:01.431Z (P40-certified); retained
   buffers may end one line earlier (.422Z) — sub-second variance is normal between
   pulls.

## 8. Actions Triggered

1. Proceed with measurement arc A1–A9 against a stable baseline (plateau makes diffing
   meaningful).
2. Record false-alarm pattern in this corpus (done here + phase41-01 §4).
3. Do NOT touch thresholds: WARN threshold stays 1400, hard 1800, limit 2000 per
   policy — P41 changes sources, not ceilings (phase41-18 §5).
