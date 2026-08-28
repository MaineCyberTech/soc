# Phase 45: IRIS Authentication Baseline

## Current Workflow State
| Property | Value |
|----------|-------|
| **Workflow** | `suricata-packet-routing` (e133a645-95b9-4e01-9454-e270d2a0b599) |
| **Action** | `iris-test-route-p39tag` (HTTP POST) |
| **Auth Header** | `Authorization: Bearer [REDACTED-IRIS-TOKEN]` (LITERAL PLACEHOLDER) |
| **Endpoint** | `https://iriswebapp_nginx:8443/alerts/add` |
| **Last Test** | HTTP 401 "Authentication required" |

## Placeholder Analysis
| Issue | Evidence | Risk |
|-------|----------|------|
| Literal `[REDACTED-IRIS-TOKEN]` in workflow | Exported workflow JSON | **CRITICAL** - placeholder in live path |
| No Shuffle auth object reference | Workflow uses raw string | **HIGH** - no secret management |
| Newline in header value | `Authorization: Bearer [REDACTED-IRIS-TOKEN]\nContent-Type:...` | **MEDIUM** - malformed header |

## Shuffle Auth Object Status
| Check | Status | Evidence |
|-------|--------|----------|
| IRIS auth object exists | **NO** | No auth object named `IRIS_API_TOKEN` in Shuffle |
| Auth object referenced in workflow | **NO** | Workflow uses raw string |
| Auth object type | N/A | Should be `Bearer Token` or `API Key` |

## IRIS Endpoint Behavior
```bash
# Test without auth
curl -X POST "https://iriswebapp_nginx:8443/alerts/add" \
  -H "Content-Type: application/json" \
  -d '{"test": "no-auth"}'
# Expected: HTTP 401 "Authentication required"

# Test with placeholder
curl -X POST "https://iriswebapp_nginx:8443/alerts/add" \
  -H "Authorization: Bearer [REDACTED-IRIS-TOKEN]" \
  -H "Content-Type: application/json" \
  -d '{"test": "placeholder"}'
# Expected: HTTP 401 "Authentication required" (placeholder invalid)
```

## Required Auth Object
| Property | Value |
|----------|-------|
| **Name** | `IRIS_API_TOKEN` |
| **Type** | `Bearer Token` |
| **Value Source** | DFIR-IRIS API token (from IRIS admin) |
| **Reference in Workflow** | `{{IRIS_API_TOKEN}}` (Shuffle template syntax) |
| **Header Format** | `Authorization: Bearer {{IRIS_API_TOKEN}}` (no newline) |

## Verification Steps
1. Create auth object in Shuffle UI: Settings → Authentication → New → Bearer Token
2. Name: `IRIS_API_TOKEN`
3. Value: [IRIS API token from IRIS admin]
4. Update workflow: Replace literal with `{{IRIS_API_TOKEN}}`
5. Test: Execute workflow → should get HTTP 200/201 from IRIS

## No-Printing Verification
- [ ] No credential values printed in this report
- [ ] No credential values in workflow export
- [ ] Auth object reference only (not value)
- [ ] Header format validated (no newline)

---
*Generated: 2026-08-27T03:49:00Z (UTC) / 2026-08-26T23:49:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING - Create auth object after capability decision (Phase 45-23)*
