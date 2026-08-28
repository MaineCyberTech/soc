# Phase 45: IRIS Authentication Object

## Approval
| Field | Value |
|-------|-------|
| **Approved By** | [Owner/Security] |
| **Approval Date** | [Date] |
| **Change Register Ref** | phase45-03-change-register.md |
| **Depends On** | Phase 45-23 capability decision = PROCEED |

## Auth Object Configuration
| Property | Value |
|----------|-------|
| **Name** | `IRIS_API_TOKEN` |
| **Type** | `Bearer Token` |
| **Category** | `API Key` |
| **Description** | DFIR-IRIS API token for alert creation via `/alerts/add` |
| **Scope** | `suricata-packet-routing` workflow only |

## Creation Procedure
1. **Obtain IRIS API Token**
   - Login to DFIR-IRIS as admin
   - Navigate to Profile → API Tokens
   - Generate new token with "Alert Create" permission
   - Copy token (shown once only)

2. **Create Shuffle Auth Object**
   - Shuffle UI → Settings → Authentication → New
   - **Name:** `IRIS_API_TOKEN`
   - **Type:** `Bearer Token`
   - **Value:** [Paste IRIS API token]
   - **Save**

3. **Verify Object**
   - Object appears in Authentication list
   - ID recorded: `auth_obj_<uuid>`

## Workflow Update
| Step | Action |
|------|--------|
| 1 | Export current workflow (Phase 45-11) |
| 2 | Replace `Authorization: Bearer [REDACTED-IRIS-TOKEN]` with `Authorization: Bearer {{IRIS_API_TOKEN}}` |
| 3 | Remove newline after auth header |
| 4 | Import updated workflow or patch via API |
| 5 | Verify workflow JSON shows `{{IRIS_API_TOKEN}}` reference |

## Header Format Validation
```yaml
# Before (INVALID)
headers: |
  Authorization: Bearer [REDACTED-IRIS-TOKEN]
  Content-Type: application/json

# After (VALID)
headers: |
  Authorization: Bearer {{IRIS_API_TOKEN}}
  Content-Type: application/json
```

## Verification
| Check | Method | Expected |
|-------|--------|----------|
| Auth object exists | Shuffle UI → Authentication | `IRIS_API_TOKEN` listed |
| Object type | UI detail view | `Bearer Token` |
| Workflow reference | Export workflow JSON | `{{IRIS_API_TOKEN}}` in headers |
| No placeholder | Export workflow JSON | No `[REDACTED-IRIS-TOKEN]` |
| No newline | Export workflow JSON | Single-line auth header |

## Test Execution
```bash
# After update, test via execute API
curl -X POST "http://127.0.0.1:5001/api/v1/workflows/e133a645-95b9-4e01-9454-e270d2a0b599/execute" \
  -H "Authorization: Bearer $NT" \
  -H "Content-Type: application/json" \
  -d '{"data": "{\"alert\":{\"signature_id\":2027967,\"src_ip\":\"10.0.0.1\",\"dest_ip\":\"192.168.1.10\",\"dest_port\":443,\"proto\":\"TCP\"}}"}'

# Check execution for IRIS HTTP 200/201
```

## Success Criteria
- [ ] Auth object `IRIS_API_TOKEN` created in Shuffle
- [ ] Workflow references `{{IRIS_API_TOKEN}}` (not literal)
- [ ] Header format valid (no newline)
- [ ] Execute API test → IRIS returns HTTP 200/201
- [ ] IRIS alert object created with valid ID

## Rollback
| Condition | Action |
|-----------|--------|
| IRIS returns 401/403 | Verify token validity; check IRIS permissions |
| Workflow error | Revert workflow to previous version (Phase 45-13 rollback) |
| Auth object issue | Delete `IRIS_API_TOKEN` object; recreate |

## Sign-Off
| Role | Name | Signature | Date |
|------|------|-----------|------|
| Security | [Name] | [Sig] | [Date] |
| Owner | [Name] | [Sig] | [Date] |

---
*Generated: 2026-08-27T03:50:00Z (UTC) / 2026-08-26T23:50:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING APPROVAL - Execute after capability decision (Phase 45-23)*
