# Phase 83 IRIS Rotation Close — P82-CRED-EXP-001 (IRIS branch)

Report ID: iris-rotation-close-08
Phase: 83
Title: Phase 83 IRIS Rotation Close — P82-CRED-EXP-001 (IRIS branch)
Date: 2026-08-31
Timestamp UTC Z: 2026-08-31T08:20:00Z
Timestamp ET EDT: 2026-08-31T04:20:00 EDT
Classification: INTERNAL
Status: PASS
Source Path: ops/reports/evidence/phase83/phase83-evidence-exposure.json
Prompt: /home/user/mct-p83/prompts/080-iris-rotation-close-08.md

## Summary
The IRIS branch (iris_api_key) of P82-CRED-EXP-001 is rotated_revoked. Rotated in Phase 82 (phase82-evidence-rotation.json): old IRIS API token revoked (returns 401), new token minted and active for service account 9001 shuffle-classa-svc, consumers (shuffle-workers service, Shuffle Tools app, wazuh-high-severity-to-iris workflow) converged, minimal grants (alerts:write / alerts:read) preserved, rollback rehearsable from backups. Incident P82-CRED-EXP-001 is CLOSED with both branches rotated_revoked. Evidence: ops/reports/evidence/phase83/phase83-evidence-exposure.json + ops/reports/evidence/phase82/phase82-evidence-rotation.json. PASS.

## Verification
- iris_api_key disposition: rotated_revoked
- phase82 rotation: old token 401 (revoked), new token 200 (active)
- consumers converged; grants preserved; rollback defined
- incident P82-CRED-EXP-001: CLOSED (both branches rotated_revoked)
- result: PASS (no secret values in any artifact)
