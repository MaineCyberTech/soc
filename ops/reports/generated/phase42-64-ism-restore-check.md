# Phase 42 ISM Restore Spot-Check #4

**Report ID:** phase42-64-ism-restore-check
**Phase:** 42
**Title:** RESTORE-CHECK #4 — PASS (Fourth Consecutive): Smallest Snapshot Index 2026.08.23 Restored From snap-20260826-0517 As restored-p42-* → GREEN → Count Parity EXACT 170,521 = 170,521 → ISM Unattached → Deleted Clean; Full Transcript Embedded; Scope Disclaimer Applies
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T09:30:00Z
**Classification:** INTERNAL
**Status:** COMPLETE — PASS (streak ×4)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-64-ism-restore-check.md`

---

## 1. Scope disclaimer

This is a SPOT-CHECK of one small index from the fs repository, proving that
snapshot payloads restore and count-match. It is NOT a full-system restore rehearsal
(that remains NO-GO pending an approved external target, per open-blockers ledger)
and makes no RTO/RPO claim.

## 2. Parameters

| Item | Value |
|---|---|
| Repository / snapshot | `wazuh-backup` (fs) / **snap-20260826-0517** (SUCCESS, latest at run time) |
| Target index | `wazuh-archives-4.x-2026.08.23` (smallest archive: 98.3mb store / 49.1mb pri) |
| Presence pre-verified | snapshot metadata lists `wazuh-archives-4.x-2026.08.23` |
| Rename | `restored-p42-wazuh-archives-4.x-2026.08.23` |
| Hygiene | replicas forced 0; ISM policy settings stripped via `ignore_index_settings` |

## 3. Full transcript (real outputs, 09:18:17–09:19:31Z)

```
=== RESTORE START 2026-08-26T09:18:17Z ===
POST /_snapshot/wazuh-backup/snap-20260826-0517/_restore?wait_for_completion=true
{ "indices":"wazuh-archives-4.x-2026.08.23",
  "rename_pattern":"wazuh-archives-4.x-2026.08.23",
  "rename_replacement":"restored-p42-wazuh-archives-4.x-2026.08.23",
  "include_aliases":false,
  "index_settings":{"index.number_of_replicas":0},
  "ignore_index_settings":["index.plugins.index_state_management.*",
                           "index.opendistro.index_state_management.*"] }
→ { "snapshot" : { "snapshot" : "snap-20260826-0517",
    "indices" : [ "restored-p42-wazuh-archives-4.x-2026.08.23" ],
    "shards" : { "total" : 1, "failed" : 0, "successful" : 1 } } }

=== HEALTH/STATE ===
_cat/indices/restored-p42-* →
restored-p42-wazuh-archives-4.x-2026.08.23 green open 170521 49.1mb 49.1mb
_cluster/health/<idx>?wait_for_status=green → "status":"green", timed_out:false

=== COUNT PARITY ===
restored _count → {"count":170521}   source _count → {"count":170521}   EXACT MATCH

=== ISM EXPLAIN (restored) ===
policy_id : null / null ; total_managed_indices : 0   ← unmanaged, cannot be waved away

=== DELETE 2026-08-26T09:19:29Z ===
DELETE /restored-p42-wazuh-archives-4.x-2026.08.23 → {"acknowledged":true}
_cat/indices/restored-p42-* → empty (removed); archives still 12 indices
```

## 4. Verdict

**PASS ×4 streak.** Snapshot restore mechanism verified again end-to-end with zero
residue. Streak lineage: three prior consecutive passes in P41 evidence + this run.
