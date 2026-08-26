# Phase 41 Field Plateau Window & Projection

**Report ID:** phase41-17-field-plateau-window
**Phase:** 41
**Title:** Phase 41 Plateau Window Continuation — Post-Containment Residual Decomposition, Method Correction, and 08.27 First-Day Projection With Guardrail Re-Check Scheduled
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:09:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-17-field-plateau-window.md`

---

## 1. Where the Window Stands

State TSV now reads:

```
2026-08-26T01:44:18Z	1604
2026-08-26T02:43:38Z	1706
2026-08-26T03:05:17Z	1706     ← plateau begins
2026-08-26T03:38:34Z	1706     ← plateau confirmed
2026-08-26T04:41:27Z	1766     ← post-containment residual
```

The three-sample plateau (1706 flat across 02:43→03:38, growth_per_day=0.0 on both)
held until containment itself changed the day's vocabulary. Today's index will close
above 1706 — mappings are append-only — so containment's proof lives entirely in
tomorrow's birth (§5–6).

## 2. The +60 Residual, Decomposed Honestly

| Component | Δ raw | Basis of estimate |
|---|---|---|
| Compact lane (design-intended) | ~34–40 | 15 flat aliases + detect_engines subtree (5 leaves) + sensor/event_type metadata, most string-mapped WITH multi-field variants → raw inflation |
| Windows trickle | ~16 | win unique 77→85 during arc morning (+8 unique ≈ +16 raw w/ multifields); phase41-11 trigger tracks this |
| Residual stats tail | ~0 | stats set was complete by 02:43 — last stats doc (03:53:31Z) mapped nothing new (still 441 unique on fresh walk) |
| Misc late mappers | remainder | normal churn |
| **Total** | **+60** | matches 1706→1766 measured |

## 3. What Tomorrow's Index Will Look Like Mechanistically

At 00:00 UTC a fresh index starts with an EMPTY mapping. Classes map as they first
arrive:

1. Non-stats families re-map essentially their whole existing vocabulary early
   (same traffic mix): ~760 raw data-leaves + 69 non-data raw.
2. Full-stats contributes **zero** — the producer no longer emits it (last-ever doc
   03:53:31Z, phase41-16 §2).
3. Compact lane contributes its fixed ~20–22 unique (~40 raw) within the first minutes.
4. Brand-new families: unknown, historically small (+~100 raw over the first hours
   observed today).

## 4. Method Correction — Why Two Projections Exist

The planning estimate carried into this arc was **≈1285**, derived as
`1706 − 441(stats) + 16(compact)`. During fresh verification this arc discovered the
basis mismatch: **441 is UNIQUE-basis while 1706 is RAW-basis**. Raw counting adds one
leaf per multi-field variant; stats carries ≈436 such variants (877 raw total,
phase41-06 §3). Correcting the basis:

| Projection | Arithmetic | Value |
|---|---|---|
| Planning estimate (conservative upper bound, mixed basis — RETAINED for safety margin) | 1706 − 441 + 16 | **≈1285 ±(new-family delta)** |
| Corrected central estimate (raw-consistent) | 1706 − 877 + ~40 + tail ~100 | **≈900 ±150** |

Both sit far below soft WARN 1400 and far below limit 2000, so **the verdict logic is
insensitive to which basis tomorrow's reading is judged on** — but the flip condition
(§6) names its band explicitly to avoid repeating the ambiguity. Lesson recorded:
basis labels are mandatory wherever counts cross reports.

## 5. Guardrail Re-Check Schedule

| When | What | Pass criterion |
|---|---|---|
| First run on `wazuh-archives-4.x-2026.08.27` (post-birth, ≥00:05Z) | `p40-field-growth-check.sh` auto-appends state row | leaf_fields(raw) ≤ 1400 (soft) AND branches show NO `stats` family dominance |
| Mid-day confirmation (~12:00Z) | second run | still <1400; win-family check vs >150 trigger (phase41-11) |
| Certification adjudication | phase41-18 flip logic executed on results | VERIFIED iff both runs within band |

## 7. Hourly Birth-Model for 08.27 (expected shape)

| Hour | Expected raw count | Driver |
|---|---|---|
| 00:00–00:05 | ~150–250 | envelope schema + first windows/ubiquiti classes + compact lane (~40) arriving immediately |
| 00:05–01:00 | ~500–700 | main family land-grab (audit/osquery/win/unifi) minus stats |
| 01:00–03:00 | ~800–950 | long-tail decoders; plateau approach |
| 03:00+ | ≈900 ±150 steady | new-family trickle only |

Compare with today's actual birth (1580 by H+1.6h) — the missing ~600+ raw leaves are
precisely the stats vocabulary that no longer exists to map.

## 8. Basis Labels on Every Number in This Report

| Number | Basis |
|---|---|
| 1604 / 1706 / 1766 series | raw (guardrail script) |
| 441 stats, 85 win, 36 ubiquiti… | unique (attribution) |
| 877 stats-raw, 168 win-raw | raw (reconciliation pairs) |
| ≈1285 projection | mixed-basis CONSERVATIVE bound (retained) |
| ≈900 ±150 projection | raw-consistent central estimate |

## 9. Failure Modes That Would Invalidate Projection

| Mode | Signature | Response |
|---|---|---|
| Stats events somehow return | any `data.stats.exists` hit on 08.27 | rollback review; check for unmasked unit / stale process |
| Compact lane silent failure | no new compact docs ≥5 min | freshness alert path; capture-health blindspot until fixed |
| Unexpected new heavy family | leaf_fields >1400 | guardrail CRIT/WARN handling per P40 policy; attribution rerun (this corpus's method) |
