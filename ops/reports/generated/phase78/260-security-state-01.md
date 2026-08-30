# Security State — RBAC Parity After Recreation (Phase 78)

**Report ID:** phase78-security-state-01
**Phase:** 78
**Title:** Security State — RBAC Parity After Recreation (Phase 78)
**Date:** 2026-08-30
**Timestamp:** 2026-08-30T19:32:14Z (UTC)
**Timestamp (America/New_York):** 2026-08-30T15:32:14 EDT
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** /home/user/mct-p78/prompts/260-security-state-01.md
**Prompt:** 260-security-state-01.md

## Verdict
PASS — security_state_after true: scoped dedup_writer write allowed; admin/foreign/security-index ops denied (403); admin-only requires admin.

## Evidence
Run with dedicated secret dedup-shuffle-dedup (user dedup_writer), TLS-validated ca:
- PUT dedup doc 201; GET count 200.
- DELETE wazuh-iris-dedup-000001 -> 403.
- PUT foreign-test-idx -> 403.
- GET .opendistro_security/_search -> 403.
Admin operations (delete index, restore) performed as admin during recreation succeeded.

## Action
Re-verified least-privilege after snapshot recreation/rollback.

## Backup-Rollback
RBAC config untouched by recreation; re-verified, not rebuilt.

## Stop-Conditions
Would STOP if scoped user could admin/foreign-write.

## Limitations
Tested against live security plugin; role unchanged from P77.
