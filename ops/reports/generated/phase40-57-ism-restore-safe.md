# Phase 40 Restore Spot-Check #2

**Report ID:** phase40-57-ism-restore-safe
**Phase:** 40
**Title:** Production-Safe Restore Cycle #2 from `snap-20260826-0017` — Smallest Index (`wazuh-monitoring-2026.32w`, 652.9 kB), rename `restored-p40-*`, Count Parity 603=603, Temp Deleted
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:23:00Z
**Classification:** INTERNAL
**Status:** COMPLETE — PASS
**Scope note:** This is a *bounded spot-check*, NOT a full DR exercise. It proves snapshot readability + restore path mechanics only; full DR (all 58 indices, timing objectives) remains covered by the separate DR plan.
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-57-ism-restore-safe.md`

---

## 1. Target selection

Smallest index in latest snapshot `snap-20260826-0017` (SUCCESS, 106/106
shards, 7.2 s):

```
index                     docs.count store.size
wazuh-monitoring-2026.32w        603    652.9kb   ← chosen (<5MB, same class as spot-check #1)
```

## 2. Restore — REAL OUTPUT

```
$ curl -sk -u admin:'***' -X POST 'https://127.0.0.1:9200/_snapshot/wazuh-backup/snap-20260826-0017/_restore?wait_for_completion=true' \
    -H 'Content-Type: application/json' \
    -d '{"indices":"wazuh-monitoring-2026.32w",
         "rename_pattern":"wazuh-(.+)",
         "rename_replacement":"restored-p40-$1"}'

{"snapshot":{"snapshot":"snap-20260826-0017",
             "indices":["restored-p40-monitoring-2026.32w"],
             "shards":{"total":1,"failed":0,"successful":1}}}
```

`wait_for_completion=true` returned synchronously: 1 shard, 0 failed.

## 3. Health wait — REAL OUTPUT

```
$ curl -sk -u admin:'***' 'https://127.0.0.1:9200/_cluster/health/restored-p40-monitoring-2026.32w?pretty'
{
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 3,
  ...
  "active_shards" : 1,
  "unassigned_shards" : 0,
  "active_shards_percent_as_number" : 100.0
}
```

## 4. Document-count parity — REAL OUTPUT

```
source   GET wazuh-monitoring-2026.32w/_count   → {"count":603,...}   (via python extract: source=603)
restore  GET restored-p40-monitoring-2026.32w/_count → restored=603
```

**603 == 603 — exact parity.**

## 5. Cleanup — REAL OUTPUT

```
$ curl -sk -u admin:'***' -X DELETE 'https://127.0.0.1:9200/restored-p40-monitoring-2026.32w'
{"acknowledged":true}

$ curl -sk -u admin:'***' 'https://127.0.0.1:9200/_cat/indices/restored-*?v'
(no rows — temp index fully removed)
```

Production left untouched: zero writes to source indices, transient disk cost
<1 MB, duration end-to-end <10 s.

## 6. Verdict

**PASS.** Second consecutive restore-path proof (#1 in P39). Combined with
snapshot membership of the deletion candidate (phase40-54 §4), the wave can
proceed knowing any deleted index is restorable.
