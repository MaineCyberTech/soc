# Phase 26 Restored Index Validation

Date: 2026-08-23
Status: **PASS**

## Validation matrix

| Check | Source | Restored (p26-restore-*) | Match |
|---|---|---|---|
| Document count | 114 | **114** | MATCH |
| Mappings (fields) | 4 | **4** | MATCH |
| Shard health | green | **green** (1 shard, 0 rep) | OK |
| Aliases | - | **none** (include_aliases:false honored) | OK |
| Read-only blocks | none | **none** | OK |
| Sample search | - | hits 1; _source keys agent/interface/network/wazuh | OK |
| Disk impact | - | ~37KB (negligible) | OK |
| Restore duration | - | wait_for_completion returned (seconds) | OK |

## Verdict

- **PASS** - OpenSearch snapshot restore is proven end-to-end for a non-security index,
  with correct docs/mappings/settings and no alias/global-state leakage.

## No secrets