# Phase 45: Webhook Trigger Baseline

## Trigger Identity
| Property | Value |
|----------|-------|
| **Trigger ID** | `736b7410-ed6a-52af-b369-89dbef6386cb` |
| **Label** | `suricata-eve-in` |
| **Type** | `WEBHOOK` |
| **Workflow** | `suricata-packet-routing` (e133a645-95b9-4e01-9454-e270d2a0b599) |
| **Workflow Revision** | Edited: 2026-08-26T20:57:45Z (1787799465) |

## Status
| Property | Value | Source |
|----------|-------|--------|
| **Requested Status** | `running` (in workflow JSON) | Workflow export |
| **Effective Status** | `stopped` | Shuffle API / UI |
| **Discrepancy** | Requested ≠ Effective | Trigger start not persisted/applied |

## Hook Registration
| Property | Value |
|----------|-------|
| **Custom URL** | `p39-suricata-test` |
| **Hook Endpoint** | `/api/v1/hooks/p39-suricata-test` (expected) |
| **Hook Validity** | **INVALID** - returns "Hook ID not valid" |
| **Registration State** | Not registered in backend |

## Backend/Worker Cache State
| Component | State |
|-----------|-------|
| **Shuffle Backend** | Running on 127.0.0.1:5001 |
| **Trigger Cache** | Not registered (stopped) |
| **Worker Pool** | Available |
| **Webhook Router** | Not routing to this trigger |

## Supported Control Paths
| Control Path | Supported | Evidence |
|--------------|-----------|----------|
| **Shuffle UI (Manual Start)** | ✅ YES | Settings → Workflows → suricata-packet-routing → Trigger → Start |
| **API: PUT /workflows/{id} with trigger status** | ❌ NO | Returns "ID in workflow data and path are not matching" |
| **API: POST /triggers/{id}/start** | ❌ NO | 404 Not Found |
| **API: POST /workflows/{id}/trigger/start** | ❌ NO | 404 Not Found |
| **API: POST /webhooks/{hook_id}** | ❌ NO | Returns "Hook ID not valid" |

## Root Cause
The trigger `status: "running"` in workflow JSON is **not persisted** to the Shuffle backend trigger registry. The backend only activates triggers when explicitly started via UI or a dedicated trigger management API (which doesn't exist in current Shuffle version).

## Required Action
**Manual start via Shuffle UI is the ONLY supported path:**
1. Open Shuffle UI
2. Navigate to Workflows → suricata-packet-routing
3. Click Trigger tab → suricata-eve-in
4. Click "Start" button
5. Verify status changes to `running`
6. Verify hook endpoint responds

## Verification Commands
```bash
# Check trigger status
curl -H "Authorization: Bearer $NT" \
  "http://127.0.0.1:5001/api/v1/workflows/e133a645-95b9-4e01-9454-e270d2a0b599" | jq '.triggers[] | {label, status}'

# Test hook after start
curl -X POST "http://127.0.0.1:5001/api/v1/hooks/p39-suricata-test" \
  -H "Content-Type: application/json" \
  -d '{"test": "probe"}'
```

## Decision Authority
Trigger start requires Owner approval per Phase 45 change register.

---
*Generated: 2026-08-27T03:43:00Z (UTC) / 2026-08-26T23:43:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
