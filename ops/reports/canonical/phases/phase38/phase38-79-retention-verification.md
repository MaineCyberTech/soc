# Phase 38-79: Retention Verification Report

**Report ID:** phase38-79-retention-verification
**Phase:** 38
**Title:** Phase 38-79: Retention Verification Report
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T21:17:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-79-retention-verification.md`

| Field | Value |
|-------|-------|
| **Report ID** | phase38-79 |
| **Generated** | 2026-08-25 21:17 UTC |
| **Classification** | Internal / Operational |
| **Owner** | MCT SOC |
| **Status** | PASS |

**Status:** PASS
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-79-retention-verification.md`
**Retention Class:** LONG

---

## 1. Executive Summary

The ISM policy `wazuh-archives-14d` is attached to and actively managing all **11** `wazuh-archives-4.x-*` indices. Every index is in state `hot`, evaluating the `min_index_age: 14d` transition (`condition_not_met` on all — correct, none has reached 14 days). **Zero deletions have been realized to date: relief = 0 GB.** First deletion ETA is **2026-08-29 ~21:00 UTC** for `wazuh-archives-4.x-2026.08.15`. No forced/manual deletion was performed this phase.

**Material correction:** the prior working claim "NO snapshot repository registered (`repository_missing_exception`)" is **STALE as of this run**. Live query of `_snapshot/_all` shows two registered repositories with fresh snapshots (Section 6). This is recorded as drift item D-03b in phase38-89.

## 2. Command Output — ISM Explain (oldest index)

```
$ curl -s -k -u admin:*** "https://127.0.0.1:9200/_plugins/_ism/explain/wazuh-archives-4.x-2026.08.15"
{
    "wazuh-archives-4.x-2026.08.15": {
        "index.plugins.index_state_management.policy_id": "wazuh-archives-14d",
        "index": "wazuh-archives-4.x-2026.08.15",
        "policy_id": "wazuh-archives-14d",
        "policy_seq_no": 241256,
        "policy_primary_term": 24,
        "index_creation_date": 1786827644251,        # 2026-08-15T21:00:44Z
        "state": { "name": "hot", ... },
        "action": { "name": "transition", ..., "failed": false },
        "step": { "name": "attempt_transition_step",
                  "step_status": "condition_not_met" },
        "info": { "message": "Evaluating transition conditions [index=wazuh-archives-4.x-2026.08.15]" },
        "enabled": true
    },
    "total_managed_indices": 1
}
```

Wildcard explain over `wazuh-archives-*`: `total_managed_indices: 11`; every index reports `state=hot`, `step=attempt_transition_step / condition_not_met`, no failures, no consumed retries.

## 3. Policy Definition

`GET _plugins/_ism/policies/wazuh-archives-14d`:

- `default_state: hot`
- `hot` → transitions to `delete` at `{"min_index_age": "14d"}`
- `delete` → action `{ "delete": {} }` with retry `{count: 3, backoff: exponential, delay: 1m}`

Policy is clean: no snapshot action inside ISM (snapshots handled by external cron), no orphan states.

## 4. Archive Index Inventory + Deletion ETA Math

`_cat/indices/wazuh-archives-*`:

| Index | Docs | Store (incl repl) | Primary | Created (UTC) | Deletion Eligible (+14d) |
|-------|------:|--------:|--------:|---------------|--------------------------|
| wazuh-archives-4.x-2026.08.15 | 3,007,251 | 1.8gb | 932.4mb | 08-15T21:00:44 | **2026-08-29T21:00:44Z** |
| wazuh-archives-4.x-2026.08.16 | 2,150,542 | 1.2gb | 649.9mb | 08-16T00:00:01 | 2026-08-30T00:00Z |
| wazuh-archives-4.x-2026.08.17 | 2,633,464 | 2.4gb | 1.2gb   | 08-17T00:00:02 | 2026-08-31T00:00Z |
| wazuh-archives-4.x-2026.08.18 | 2,397,160 | 2.0gb | 1.0gb   | 08-18T00:00:01 | 2026-09-01T00:00Z |
| wazuh-archives-4.x-2026.08.19 | 2,519,199 | 3.8gb | 1.9gb   | 08-19T00:00:01 | 2026-09-02T00:00Z |
| wazuh-archives-4.x-2026.08.20 | 1,486,141 | 1.2gb | 622.4mb | 08-20T00:00:02 | 2026-09-03T00:00Z |
| wazuh-archives-4.x-2026.08.21 | 1,423,025 | 1.2gb | 627.4mb | 08-21T00:00:03 | 2026-09-04T00:00Z |
| wazuh-archives-4.x-2026.08.22 |   599,196 | 707.8mb | 357.2mb | 08-22T00:00:02 | 2026-09-05T00:00Z |
| wazuh-archives-4.x-2026.08.23 |   170,521 |  98.3mb |  49.1mb | 08-23T00:00:02 | 2026-09-06T00:00Z |
| wazuh-archives-4.x-2026.08.24 |   248,458 | 139.8mb |  69.8mb | 08-24T00:00:02 | 2026-09-07T00:00Z |
| wazuh-archives-4.x-2026.08.25 |   743,287 | 499.3mb | 247.3mb | 08-25T00:00:02 | 2026-09-08T00:00Z |
| **TOTAL** | **17,378,244** | **≈15.0 GB** | **≈7.6 GB** | | |

## 5. Realized Relief and Plateau Analysis

- **Realized relief: 0 GB.** No index has aged out; `_cat/indices` shows all 11 open with full doc counts.
- **Growth vs release balance (observed):** daily archive creation averages ≈1.36 GB/day incl replicas (15.0 GB ÷ 11 days). Until 2026-08-29 the stack is net-accumulating; disk will continue toward the watermark.
- **Plateau point:** steady-state plateau (deletes ≈ creates) is expected ~**2026-09-12 ± 1 day**, i.e., once the first 7 daily indices have rolled out of retention, assuming flat ingest volume (~1.3–1.5 GB/day). At plateau, archives hold a rolling ~14-day window ≈ **19–21 GB**.
- **Disk context:** root filesystem 117G/148G used (**83%** per `_cat/allocation` per-node; host `df` 83%); 25G available. Watermark headroom is adequate but the 85% flood-stage warning band is only ~3 GB away if ingest spikes.
- **First-week relief projection:** 2026-08-29 → 09-04 deletions free ≈ **11.9 GB** cumulative (indices 08.15–08.21).

## 6. Snapshot Repository Status — CORRECTED

Prior state records asserted `repository_missing_exception`. Live verification contradicts this:

```
$ GET _cat/repositories
id           type
wazuh-backup fs
do-spaces    s3

$ GET _snapshot/wazuh-backup/_all  → 42 snapshots; latest:
  snap-20260825-0517 / -1017 / -1517 / -2017 (56 indices each)

$ GET _snapshot/do-spaces/_all     → 85 snapshots; latest:
  s3-snap-20260825-1047 / -1547 / -2047 (94–95 indices each)
```

Both repos are healthy and current within the last hour (fs via `elastic-snapshot.sh` cron 03:30 UTC + additional runs; s3 via `elastic-snapshot-s3.sh`). All archive indices 08.15+ are covered by today's snapshots. **Retention deletes are now provably safe** (restore path exists prior to first expiry). The stale `repository_missing_exception` observation likely predates repo registration and must be corrected in current-state docs (ref phase38-89 D-03b).

## 7. Constraints & Non-Actions

- NO forced deletion was performed this phase (`DELETE index` not invoked).
- No policy modification was made; `min_index_age: 14d` left intact.
- Note: an idempotent `_ism/add` re-attach call was issued during verification against an already-managed index; it is a no-op for attached indices and changed nothing.

## 8. Next Verification

Re-run explain + `_cat/allocation` on **2026-08-30** to capture the first realized deletion (index 08.15) and measure actual GB relieved vs the 1.8 GB forecast.

---
*Evidence: curl outputs captured 2026-08-25 21:00–21:17 UTC. No secrets printed.*
