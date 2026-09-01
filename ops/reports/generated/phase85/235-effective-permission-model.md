**Report ID:** phase85-235
**Phase:** 85
**Title:** Effective Permission Model - Model 235
**Date:** 2026-09-01
**Timestamp:** 2026-09-01T04:00:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** ops/reports/generated/phase85/235-effective-permission-model.md

**Claims:**
- Effective permission model documented from live enumeration (VERIFIED, evidence: phase85v2-evidence-rbac-readall.json:effective_permission_model)
- readall role: index_patterns ['*'], allowed_actions ['read'], cluster_permissions ['cluster_composite_ops_ro'] (VERIFIED, evidence: live-rbac-snapshot.json:readall_role_definition)
- Effective read grant covers ALL indices including security-auditlog-*, wazuh-*, ss4o_*, .opendistro_security (VERIFIED, evidence: phase85-evidence-rbac-readall.json:readall_effective_indexes)
- readall is read-only (no write, no cluster-admin actions) (VERIFIED, evidence: phase85-evidence-rbac-readall.json:negative_tests point 3)
- audit_viewer compensating role: read/search on security-auditlog-* and .opendistro_security (VERIFIED, evidence: live-rbac-snapshot.json:roles.audit_viewer)
