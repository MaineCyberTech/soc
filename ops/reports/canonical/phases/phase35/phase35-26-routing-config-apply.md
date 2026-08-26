# Phase 35: Production Routing Apply

Date: 2026-08-25

## Status: NOT APPLIED (routing deferred per prompt 25)

## Reason
No Shuffle workflow exists. Production routing requires:
1. Shuffle workflow for SID 2027967
2. Dedup integration
3. Daily counter
4. Malformed handling

## What would be applied (when approved)
- Enable SID 2027967 routing only
- All other SIDs remain observe-only
- analysisd unchanged
- Rollback: Remove workflow + disable cron

## Current routing
- SID 2027967: observe-only (alerts indexed in OpenSearch, no routing)
- All other SIDs: observe-only

## No changes made
## No secrets
