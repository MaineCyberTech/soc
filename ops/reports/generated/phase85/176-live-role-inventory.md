**Report ID:** phase85-176
**Phase:** 85
**Title:** Live Role Inventory - Role 176
**Date:** 2026-09-01
**Timestamp:** 2026-09-01T04:00:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** ops/reports/generated/phase85/176-live-role-inventory.md

**Claims:**
- Live roles enumeration complete via Security API GET /_plugins/_security/api/roles (VERIFIED, evidence: phase85v2-evidence-rbac-readall.json:role_inventory_complete)
- 54 roles captured including all_access, readall, audit_viewer, kibana_server, logstash, manage_wazuh_index (VERIFIED, evidence: live-rbac-snapshot.json:roles)
- readall role definition unchanged: index_patterns ['*'], allowed_actions ['read'], cluster_permissions ['cluster_composite_ops_ro'] (VERIFIED, evidence: live-rbac-snapshot.json:readall_role_definition)
- audit_viewer role predefined for audit separation: read/search on security-auditlog-* and .opendistro_security (VERIFIED, evidence: live-rbac-snapshot.json:roles.audit_viewer)
- Reserved/static roles cataloged (VERIFIED, evidence: phase85v2-evidence-rbac-readall.json:reserved_resources_cataloged)
