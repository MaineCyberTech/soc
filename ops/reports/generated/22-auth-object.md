# Phase 46: Auth Object Creation Plan

## Purpose
Plan the creation of an IRIS authentication object in Shuffle for proper API integration.

## Findings

### Creation Steps
1. Navigate to **Shuffle UI → Settings → Authentication**
2. Create new auth object with the following properties:
   - **Type:** API Key / Bearer Token
   - **Name:** `IRIS_API_TOKEN` (suggested)
   - **Value:** Real DFIR-IRIS token (obtained from IRIS UI)
3. Update workflow to reference auth object instead of placeholder

### Current State
- Workflow uses literal string `[REDACTED-IRIS-TOKEN]` in execute_python code
- No auth object is referenced by the workflow
- IRIS API calls fail with 401

### Target State
- Workflow references auth object via `$IRIS_API_TOKEN` or auth object reference
- IRIS API calls succeed with valid bearer token
- Token management centralized in Shuffle settings

### Prerequisites
- Real DFIR-IRIS API token must be generated from IRIS UI
- Shuffle admin access to Settings → Authentication
- Workflow edit permissions

## Verification
- [ ] IRIS API token generated from IRIS UI
- [ ] Auth object created in Shuffle UI (Settings → Authentication)
- [ ] Auth object named `IRIS_API_TOKEN`
- [ ] Workflow updated to reference auth object
- [ ] `[REDACTED-IRIS-TOKEN]` placeholder removed from code
- [ ] IRIS API calls return 200/201 after update

---
*Generated: 2026-08-27T06:22:00Z (UTC) / 2026-08-27T02:22:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
