# Phase 45: Field C1-C5 Adjudication

## C1: Limit (Archive Field Limit)
| Metric | Value | Evidence |
|--------|-------|----------|
| **Current Limit** | [Value] | OpenSearch ISM policy |
| **Phase 44 Claim** | 512 insufficient | Phase 44 report |
| **New-Cycle Actual** | [Value] | OpenSearch index stats |
| **Verdict** | [PASS/FAIL] |  |

**Evidence:**
```bash
# Check OpenSearch ISM policy
curl -X GET "https://opensearch:9200/_plugins/_ism/policies/field-limit-policy" \
  -H "Authorization: Bearer $OPENSEARCH_TOKEN"
```

## C2: ISM (Index State Management)
| Metric | Value | Evidence |
|--------|-------|----------|
| **ISM Policy Attached** | [Y/N] | OpenSearch _ism API |
| **Policy ID** | [ID] |  |
| **Rollover Conditions** | [Details] |  |
| **Delete Conditions** | [Details] |  |
| **Phase 44 Claim** | Policy attached | Phase 44 report |
| **New-Cycle Actual** | [Verified] | OpenSearch _ism API |
| **Verdict** | [PASS/FAIL] |  |

**Evidence:**
```bash
curl -X GET "https://opensearch:9200/_plugins/_ism/explain/mct-*" \
  -H "Authorization: Bearer $OPENSEARCH_TOKEN"
```

## C3: Full-Stats Absence
| Metric | Value | Evidence |
|--------|-------|----------|
| **Full-Stats Enabled** | [Y/N] | OpenSearch index settings |
| **Phase 44 Claim** | Absent (causes limit issues) | Phase 44 report |
| **New-Cycle Actual** | [Verified] | OpenSearch index settings |
| **Verdict** | [PASS/FAIL] |  |

## C4: Zero New-Cycle Rejections
| Metric | Value | Evidence |
|--------|-------|----------|
| **New-Cycle Rejections** | [Count] | OpenSearch logs / indexing errors |
| **Phase 44 Claim** | Zero | Phase 44 report |
| **New-Cycle Actual** | [Verified] | OpenSearch indexing stats |
| **Verdict** | [PASS/FAIL] |  |

**Evidence:**
```bash
curl -X GET "https://opensearch:9200/_cat/indices/mct-*?v&h=index,docs.count,docs.deleted,store.size" \
  -H "Authorization: Bearer $OPENSEARCH_TOKEN"
```

## C5: Required Data
| Metric | Value | Evidence |
|--------|-------|----------|
| **Required Fields Present** | [Y/N] | Sample document check |
| **Phase 44 Claim** | Complete | Phase 44 report |
| **New-Cycle Actual** | [Verified] | Sample document |
| **Verdict** | [PASS/FAIL] |  |

## Label Count Bases
| Label | Count Base | Evidence |
|-------|------------|----------|
| **Total Documents** | [Count] | OpenSearch `_count` |
| **Rejected Documents** | [Count] | Rejection index / logs |
| **Archived Documents** | [Count] | Archive index count |
| **Rollover Cycles** | [Count] | ISM policy execution history |

## New-Cycle Index Evidence
```bash
# Check new-cycle index
INDEX="mct-$(date -u +%Y.%m.%d)"
curl -X GET "https://opensearch:9200/${INDEX}/_stats/docs,store" \
  -H "Authorization: Bearer $OPENSEARCH_TOKEN"

# Check ISM policy on new-cycle
curl -X GET "https://opensearch:9200/_plugins/_ism/explain/${INDEX}" \
  -H "Authorization: Bearer $OPENSEARCH_TOKEN"

# Check field limit
curl -X GET "https://opensearch:9200/${INDEX}/_settings" \
  -H "Authorization: Bearer $OPENSEARCH_TOKEN" | jq '.["index.mapping.total_fields.limit"]'
```

## Adjudication Summary
| Criterion | Phase 44 Claim | New-Cycle Evidence | Verdict |
|-----------|----------------|--------------------|---------|
| **C1: Limit** | 512 insufficient | [Value] | [PASS/FAIL] |
| **C2: ISM** | Policy attached | [Verified] | [PASS/FAIL] |
| **C3: Full-Stats** | Absent | [Verified] | [PASS/FAIL] |
| **C4: Zero Rejections** | Zero | [Count] | [PASS/FAIL] |
| **C5: Required Data** | Complete | [Verified] | [PASS/FAIL] |

## Overall Field Certification
| Overall | Criteria |
|---------|----------|
| **PASS** | All 5 criteria PASS |
| **PARTIAL** | 1-2 PARTIAL, rest PASS |
| **FAIL** | Any FAIL |

## Field Certification Result
**OVERALL: [PASS/PARTIAL/FAIL]**

## Label Count Attribution
| Label | Count | Base |
|-------|-------|------|
| Total Documents (new-cycle) | [N] | OpenSearch `_count` |
| Field Limit | [Value] | Index settings |
| ISM Policy | [ID] | ISM API |
| Full-Stats | [Enabled/Disabled] | Index settings |
| Rejections | [Count] | Rejection logs |

## Sign-Off
| Role | Name | Signature | Date |
|------|------|-----------|------|
| Field Owner | [Name] | [Sig] | [Date] |
| Platform | [Name] | [Sig] | [Date] |
| Security | [Name] | [Sig] | [Date] |

---
*Generated: 2026-08-27T04:23:00Z (UTC) / 2026-08-27T00:23:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING - Execute after production apply (Phase 45-49)*
