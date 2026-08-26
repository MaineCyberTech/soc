# Phase 42 Condition C3 — Zero Full-Stats Docs — PENDING-BIRTH (interim GREEN)

**Report ID:** phase42-07-c3-fullstats-condition
**Phase:** 42
**Title:** C3 Adjudication Package — Zero Full-Stats in Newborn; Interim Live Proof: 0 Docs Since 03:54Z Cutover on Legacy Index
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T08:34:11Z
**Classification:** INTERNAL
**Status:** PENDING-BIRTH (interim evidence GREEN)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-07-c3-fullstats-condition.md`

---

## 1. Condition

The newborn index must contain **zero** `data.event_type:"stats"` full-stats documents —
the emitter was surgically removed at the 03:53Z cutover (P41 containment); only the
bounded compact-stats lane remains.

## 2. Exact check (from adjudicator)

```bash
curl -sk -u admin:${PW} 'https://127.0.0.1:9200/wazuh-archives-4.x-2026.08.27/_count?q=data.event_type:%22stats%22'
```

Pass band: `"count":0`. Any count >0 → FAIL (a full-stats doc leaked into the new day).

## 3. CURRENT interim status — fresh run embedded (08:15Z)

Post-cutover window on today's legacy index:

```json
$ _count {"bool":{"filter":[{"term":{"data.event_type":"stats"}},
                            {"range":{"timestamp":{"gte":"2026-08-26T03:54:00Z"}}}]}}
{"count":0,"_shards":{"total":1,"successful":1,"skipped":0,"failed":0}}
```

Whole-day context (honesty row):

```
$ _count?q=data.event_type:"stats" on wazuh-archives-4.x-2026.08.26 → {"count":166}
```

Those 166 are **legacy pre-cutover docs (00:00–03:53Z)**; the post-cutover count is zero,
i.e. containment held for ~4h40m continuously as of this read.

## 4. Post-birth action

Adjudicator C3 line goes verbatim into report 13. Because the newborn starts empty, a
single `_count` at t+adjudication is decisive; repeat at plateau samples (t+6h, t+24h per
report 14) to prove no late-emitter regression.
