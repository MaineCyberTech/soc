**Report ID:** phase85-252
**Phase:** 85
**Title:** Readall Current Scope - Scope 252
**Date:** 2026-09-01
**Timestamp:** 2026-09-01T04:00:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** ops/reports/generated/phase85/252-readall-current-scope.md

**Claims:**
- Readall current scope confirmed via live enumeration (VERIFIED, evidence: phase85v2-evidence-rbac-readall.json:readall_current_scope)
- Readall role mapped to backend_roles:['readall'] (catch-all backend-role mapping PRESENT) (VERIFIED, evidence: live-rbac-snapshot.json:rolesmapping.readall)
- Phase 84 claim of catch-all reduction to explicit-user-only NOT reflected in live config (VERIFIED, evidence: phase85-evidence-rbac-readall.json:semantic_diff point 1)
- Internal users holding readall backend_role: 'readall', 'kibanaro' (VERIFIED, evidence: phase85-evidence-rbac-readall.json:readall_users)
- Any identity assigned backend_role 'readall' inherits catch-all read grant (VERIFIED, evidence: phase85-evidence-rbac-readall.json:readall_backend_roles)
