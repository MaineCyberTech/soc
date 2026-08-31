# Phase 83 OpenSearch Exposure Scope — Incident P82-CRED-EXP-001

Report ID: opensearch-exposure-scope-09
Phase: 83
Title: Phase 83 OpenSearch Exposure Scope — Incident P82-CRED-EXP-001
Date: 2026-08-31
Timestamp UTC Z: 2026-08-31T08:20:00Z
Timestamp ET EDT: 2026-08-31T04:20:00 EDT
Classification: INTERNAL
Status: PASS
Source Path: ops/reports/evidence/phase83/phase83-evidence-exposure.json
Prompt: /home/user/mct-p83/prompts/090-opensearch-exposure-scope-09.md

## Summary
The exposed OpenSearch branch is the Wazuh indexer admin credential opensearch_admin_password, terminal-exposed in Phase 81. Exposure scope was determined value-blind (by variable name / pattern only; the literal value was never printed, echoed, hashed, or committed). All locations were scanned in Phase 82 (shell history, session logs, process args, artifacts, git history, backups) and re-affirmed here. The credential was rotated and the old material revoked in Phase 83 (phase83-evidence-rotation.json: old rejected 401, new works 200, filebeat consumers converged, admin grants preserved, OpenSearch security audit captured the rotation). Disposition: rotated_revoked. Evidence: ops/reports/evidence/phase83/phase83-evidence-exposure.json + ops/reports/evidence/phase83/phase83-evidence-rotation.json. PASS.

## Verification
- exposed branch: opensearch_admin_password (Wazuh indexer / OpenSearch admin)
- scope_method: value-blind (by name/pattern only; no secret value printed)
- all_locations_scanned: true
- phase83 rotation: old rejected 401, new active 200, consumers converged
- disposition: rotated_revoked
- result: PASS
