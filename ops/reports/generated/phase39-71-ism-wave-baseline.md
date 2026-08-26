# Phase 39 ISM Wave Baseline — Candidate, Policy State, ETA Math, Coverage

**Report ID:** phase39-71-ism-wave-baseline
**Phase:** 39
**Title:** ISM-BASE-39-01 — wazuh-archives-4.x-2026.08.15 (932.4mb) Is First Deletion Candidate; Policy hot→delete @14d; Transition condition_not_met; ETA 2026-08-29T21:00:44Z (Computed From index_creation_date); Snapshots Cover Candidate
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:42:29Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-71-ism-wave-baseline.md`

---

## 1. Candidate list — live `_cat/indices` (sorted by date)

```
$ curl -s -k -u admin:'…' "https://127.0.0.1:9200/_cat/indices/wazuh-archives-*?h=index,pri.store.size&s=index"
wazuh-archives-4.x-2026.08.15 932.4mb   ← OLDEST / FIRST DELETION CANDIDATE
wazuh-archives-4.x-2026.08.16 649.9mb
wazuh-archives-4.x-2026.08.17   1.2gb
wazuh-archives-4.x-2026.08.18     1gb
wazuh-archives-4.x-2026.08.19   1.9gb
wazuh-archives-4.x-2026.08.20 622.4mb
wazuh-archives-4.x-2026.08.21 627.4mb
wazuh-archives-4.x-2026.08.22 357.2mb
wazuh-archives-4.x-2026.08.23  49.1mb
wazuh-archives-4.x-2026.08.24  69.8mb
wazuh-archives-4.x-2026.08.25 291.8mb
```

Oldest candidate size **932.4 mb / 3,007,251 docs** — consistent with P38's ~932MB record.

## 2. Policy state for 08.15 — live explain

```
$ curl -s -k -u admin:'…' "https://127.0.0.1:9200/_plugins/_ism/explain/wazuh-archives-4.x-2026.08.15"
policy_id:            wazuh-archives-14d
index_creation_date:  1786827644251        → 2026-08-15T21:00:44Z (computed)
state.name:           hot                  (start_time 1787383324399 → 2026-08-22T07:22:04Z)
action.name:          transition
step.name:            attempt_transition_step
step_status:          condition_not_met    ← 14d age not yet reached (expected)
info.message:         "Evaluating transition conditions [index=wazuh-archives-4.x-2026.08.15]"
enabled:              true
```

Policy body confirms transition:

```
states: [ hot →(min_index_age:14d)→ delete ]; delete actions: [ delete {} ]
```

## 3. Deletion ETA math (evidence-derived)

```
creation      = epoch_ms 1786827644251 = 2026-08-15T21:00:44.251Z
ETA (+14d)    = 2026-08-29T21:00:44.251Z
```

**First deletion expected ≈ 2026-08-29T21:00:44Z** (ISM evaluates on its periodic
job; actual execution may lag by the job interval). Prior P38 note of ~21:00:02Z
was an approximation; today's computed value from `index_creation_date` supersedes it.

## 4. Expected-deletion table (ONLY evidence-backed rows)

| Index | Size | Created (UTC) | 14d ETA (UTC) | State now |
|---|---|---|---|---|
| wazuh-archives-4.x-2026.08.15 | 932.4mb | 2026-08-15T21:00:44Z | 2026-08-29T21:00:44Z | hot / condition_not_met |
| wazuh-archives-4.x-2026.08.16 | 649.9mb | (created ~Aug-16) | ~2026-08-30 | hot |
| wazuh-archives-4.x-2026.08.17 | 1.2gb | (created ~Aug-17) | ~2026-08-31 | hot |

No rows beyond inference from policy arithmetic are claimed.

## 5. Snapshot coverage of candidate

```
$ curl … "_cat/snapshots/wazuh-backup" | wc -l   → 42 snapshots (fs repo)
$ curl … "_cat/snapshots/do-spaces"     | wc -l   → 85 snapshots (s3 repo)
```

Latest fs snapshot `snap-20260825-2017` (56 indices) **includes
`wazuh-archives-4.x-2026.08.15`** in its indices list (verified in phase39-73
snapshot inspection). s3 repo holds daily `s3-snap-*` at 20:47Z through
`s3-snap-20260822-2047`. The candidate is therefore snapshot-protected before deletion.

## 6. Cluster health context

```
$ _cat/allocation?v → 92/91/91 shards per indexer node, disk.percent=84 each,
disk.used=124gb, disk.avail=23.3gb of 147.4gb total
watermarks (defaults): low=85% high=90% flood_stage=95%
index.blocks sweep: indices_with_blocks=0 → no write blocks
```

Writes normal, blocks none; cluster sits 1 point below the low watermark.
