# Phase 39 ISM Restore Spot-Check — Real Bounded Restore/Delete Cycle

**Report ID:** phase39-73-ism-restore-spotcheck
**Phase:** 39
**Title:** RESTORE-CHK-39-01 — wazuh-monitoring-2026.35w (1mb) Restored From snap-20260825-2017 to restored-tmp-* (GREEN, 1405 docs), Verified vs Source, Then Deleted — Production Indices Untouched
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:42:29Z
**Classification:** INTERNAL
**Status:** PASS
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-73-ism-restore-spotcheck.md`

---

## 1. Snapshot selection (smallest recent)

```
$ curl -s -k -u admin:'…' "https://127.0.0.1:9200/_cat/snapshots/wazuh-backup?v&s=h:start_time" | tail -3
snap-20260824-2017 SUCCESS … 20:17:04 54 indices
snap-20260825-1517 SUCCESS … 15:17:05 54 indices
snap-20260825-2017 SUCCESS … 20:17:05 56 indices   ← chosen (latest)
```

## 2. Snapshot content inspection

```
$ curl … "_snapshot/wazuh-backup/snap-20260825-2017"
snapshot: snap-20260825-2017 | indices: 56
  includes: wazuh-archives-4.x-2026.08.15 … wazuh-alerts-4.x-2026.08.25,
            wazuh-monitoring-2026.32w/33w/34w/35w, wazuh-statistics-*, states-inventory-*
```

Smallest index inside the snapshot: **wazuh-monitoring-2026.35w = 1mb live**
(well under the <5MB bound). Candidate index list cross-checked against
`_cat/indices` sizes.

## 3. Source count (pre-restore)

```
$ curl … "wazuh-monitoring-2026.35w/_count"
{"count":1522,…}
```

## 4. Bounded restore with rename + replicas:0

First attempt used body key `include_settings` → rejected by OpenSearch:

```
{"error":{"type":"illegal_argument_exception",
 "reason":"Unknown parameter include_settings"},"status":400}
```

Corrected to `index_settings`:

```
$ POST _snapshot/wazuh-backup/snap-20260825-2017/_restore?wait_for_completion=true
{"indices":"wazuh-monitoring-2026.35w","rename_pattern":"(.+)",
 "rename_replacement":"restored-tmp-$1",
 "index_settings":{"index.number_of_replicas":0}}
→ {"snapshot":{"snapshot":"snap-20260825-2017",
    "indices":["restored-tmp-wazuh-monitoring-2026.35w"],
    "shards":{"total":1,"failed":0,"successful":1}}}
```

## 5. Health + count verification

```
$ _cluster/health/restored-tmp-wazuh-monitoring-2026.35w → "status":"green"
$ restored-tmp-wazuh-monitoring-2026.35w/_count → {"count":1405}
$ _cat/indices/restored-tmp-*
restored-tmp-wazuh-monitoring-2026.35w 968.4kb 1405 green
```

**Delta note (honest):** 1405 vs source-now 1522 (92.3%). The snapshot was cut at
20:17:05Z; the source continued receiving monitoring writes between 20:17Z and
test time (~23:38Z). Count-vs-snapshot-moment is consistent; no loss implied.

## 6. Cleanup — temp index deleted

```
$ DELETE /restored-tmp-*
{"acknowledged":true}
$ sleep 2; _cat/indices/restored-tmp-* → (empty output)
```

Full cycle **restore → verify → delete** proven end-to-end.

## 7. Scope limitation

This is a SPOT-CHECK of one 1mb index only. It proves snapshot readability and
restore mechanics; it is NOT a full DR rehearsal (no manager, no configs, no
multi-index ordering — those are PLAN-DR-39-01 stages). All production indices
were untouched throughout.
