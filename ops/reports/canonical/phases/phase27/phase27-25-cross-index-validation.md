# Phase 27 Cross-Index Restore Validation

Date: 2026-08-24
Status: **PASS**

## Per-index comparison

| Index | Source (live) | Restored (p27-restore-*) | Mappings | Match |
|---|---|---|---|---|
| ports | 2314 | **2248** (snapshot point-in-time; +66 live docs added after snapshot) | 9 == 9 | MATCH (snapshot) |
| protocols | 114 | **114** | 4 == 4 | MATCH |
| groups | 447 | **447** | 3 == 3 | MATCH |

- Restored counts equal the snapshot content (live deltas since 05:17 snapshot explain the
  ports gap) - point-in-time consistency proven.

## Cross-index search

- `p27-restore-*/_search` -> 2,809 hits across the restored set (agent/group/wazuh fields).

## Shards / aliases / blocks

- All restored: green; aliases: none; read-only blocks: 0. Restore time: wait_for_completion
  returned (seconds); disk impact ~730KB.

## Verdict

- **PASS** - multi-index restore + cross-index query validation complete.

## No secrets