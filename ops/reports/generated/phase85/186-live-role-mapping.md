**Report ID:** phase85-186
**Phase:** 85
**Title:** Live Role Mapping - Mapping 186
**Date:** 2026-09-01
**Timestamp:** 2026-09-01T04:00:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** ops/reports/generated/phase85/186-live-role-mapping.md

**Claims:**
- Live rolesmapping enumeration complete via Security API GET /_plugins/_security/api/rolesmapping (VERIFIED, evidence: phase85v2-evidence-rbac-readall.json:role_mapping_complete)
- readall role mapped to backend_roles:['readall'] (catch-all still present) (VERIFIED, evidence: live-rbac-snapshot.json:rolesmapping.readall)
- audit_viewer role UNMAPPED in live rolesmapping (no backend_roles, no users) (VERIFIED, evidence: live-rbac-snapshot.json:rolesmapping.audit_viewer)
- Dangling p83_lowpriv_role binding to user p83_lowpriv (role/user not exist live) (VERIFIED, evidence: phase85-evidence-rbac-readall.json:semantic_diff point 3)
- all_access mapped to backend_roles:['admin'] only (VERIFIED, evidence: live-rbac-snapshot.json:rolesmapping.all_access)
