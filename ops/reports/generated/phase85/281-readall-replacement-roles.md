**Report ID:** phase85-281
**Phase:** 85
**Title:** Readall Replacement Roles - Role 281
**Date:** 2026-09-01
**Timestamp:** 2026-09-01T04:00:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** ops/reports/generated/phase85/281-readall-replacement-roles.md

**Claims:**
- Replacement roles identified but not yet enforced (VERIFIED, evidence: phase85v2-evidence-rbac-readall.json:readall_replacement_roles)
- audit_viewer: predefined, read/search on security-auditlog-* and .opendistro_security (VERIFIED, evidence: live-rbac-snapshot.json:roles.audit_viewer)
- soc_least_priv: candidate narrow SOC operational read role (to be provisioned and mapped) (VERIFIED, evidence: phase85-evidence-rbac-readall.json:replacement_roles)
- Both must be mapped and verified convergent BEFORE exception expiry 2026-09-30 (VERIFIED, evidence: phase85-evidence-rbac-readall.json:replacement_roles)
- No replacement cutover performed this phase (VERIFIED, evidence: phase85-evidence-rbac-readall.json:cutover_approval_or_blocker)
