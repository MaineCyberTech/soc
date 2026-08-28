# Phase 45: Post-Deletion Restore Proof

## Pre-conditions
- [ ] Phase 45-77 Wave Observed
- [ ] Deleted indices identified
- [ ] Snapshot exists for deleted indices
- [ ] Isolated test scope prepared

## Restore Scope
| Index | Original Size | Snapshot | Snapshot Date |
|-------|---------------|----------|---------------|
| [Index] | [GB] | [Snapshot ID] | [Date] |

## Restore Procedure
```bash
# 1. Create isolated restore index (different name)
curl -X POST "https://opensearch:9200/_snapshot/<repo>/<snapshot>/_restore" \
  -H "Authorization: Bearer $OPENSEARCH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "indices": "<index>",
    "rename_pattern": "(.+)",
    "rename_replacement": "restored_$1",
    "include_global_state": false
  }'
```

## Verification
| Check | Expected | Actual | Pass/Fail |
|-------|----------|--------|-----------|
| **Restore Initiated** | Accepted | [Status] | [PASS/FAIL] |
| **Restore Complete** | SUCCESS | [Status] | [PASS/FAIL] |
| **Doc Count Match** | Original count | [Count] | [PASS/FAIL] |
| **Doc Count Restored** | Original count | [Count] | [PASS/FAIL] |
| **Checksum Match** | Original SHA256 | [SHA256] | [PASS/FAIL] |
| **Mapping Match** | Original mapping | [Mapping] | [PASS/FAIL] |
| **Settings Match** | Original settings | [Settings] | [PASS/FAIL] |
| **Isolated** | Separate index name | [Index name] | [PASS/FAIL] |

## Parity Validation
```bash
# Compare original (if available) vs restored
curl -X GET "https://opensearch:9200/<original>/_count" -H "Authorization: Bearer $OPENSEARCH_TOKEN"
curl -X GET "https://opensearch:9200/restored_<original>/_count" -H "Authorization: Bearer $OPENSEARCH_TOKEN"

# Compare mappings
curl -X GET "https://opensearch:9200/<original>/_mapping" -H "Authorization: Bearer $OPENSEARCH_TOKEN"
curl -X GET "https://opensearch:9200/restored_<original>/_mapping" -H "Authorization: Bearer $OPENSEARCH_TOKEN"

# Sample document comparison
curl -X GET "https://opensearch:9200/<original>/_search?size=10" -H "Authorization: Bearer $OPENSEARCH_TOKEN"
curl -X GET "https://opensearch:9200/restored_<original>/_search?size=10" -H "Authorization: Bearer $OPENSEARCH_TOKEN"
```

## Verification Checklist
| Check | Expected | Actual | Pass/Fail |
|-------|----------|--------|-----------|
| **Restore Initiated** | Accepted | [Status] | [PASS/FAIL] |
| **Restore Complete** | SUCCESS | [Status] | [PASS/FAIL] |
| **Doc Count Match** | Exact | [Count] | [PASS/FAIL] |
| **Checksum Match** | Exact | [SHA256] | [PASS/FAIL] |
| **Mapping Match** | Exact | [Mapping] | [PASS/FAIL] |
| **Settings Match** | Exact | [Settings] | [PASS/FAIL] |
| **Isolated Scope** | Separate index | [Index name] | [PASS/FAIL] |
| **No Production Impact** | Isolated | [Confirmed] | [PASS/FAIL] |

## Cleanup
```bash
# Delete restored test index
curl -X DELETE "https://opensearch:9200/restored_<original>" \
  -H "Authorization: Bearer $OPENSEARCH_TOKEN"
```

## Verification
| Check | Pass/Fail |
|-------|-----------|
| Restore initiated | [PASS/FAIL] |
| Restore complete | [PASS/FAIL] |
| Doc count match | [PASS/FAIL] |
| Checksum match | [PASS/FAIL] |
| Mapping match | [PASS/FAIL] |
| Settings match | [PASS/FAIL] |
| Isolated scope | [PASS/FAIL] |
| Cleanup complete | [PASS/FAIL] |

## Verdict
**RESTORE PROOF: [PASS/FAIL]**

## If FAIL
**Blocking Issues:**
1. [Issue 1]
2. [Issue 2]

**Remediation:** [Plan]
**Re-evaluation:** [Date]

## Sign-Off
| Role | Name | Signature | Date |
|------|------|-----------|------|
| Owner | [Name] | [Sig] | [Date] |
| Platform | [Name] | [Sig] | [Date] |
| Security | [Name] | [Sig] | [Date] |

---
*Generated: 2026-08-27T04:51:00Z (UTC) / 2026-08-27T00:51:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING - Execute after ISM wave (Phase 45-77)*
