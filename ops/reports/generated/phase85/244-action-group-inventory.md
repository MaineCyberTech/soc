**Report ID:** phase85-244
**Phase:** 85
**Title:** Action Group Inventory - Group 244
**Date:** 2026-09-01
**Timestamp:** 2026-09-01T04:00:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** ops/reports/generated/phase85/244-action-group-inventory.md

**Claims:**
- Action groups enumerated via Security API GET /_plugins/_security/api/actiongroups (VERIFIED, evidence: phase85v2-evidence-rbac-readall.json:action_group_inventory)
- Endpoint tested: 200 OK on actiongroups endpoint (VERIFIED, evidence: phase85v2-evidence-security-api.json:details.authenticated_access.endpoints_tested./_plugins/_security/api/actiongroups)
- Read-only enumeration confirmed (GET allowed, POST/PUT/DELETE denied) (VERIFIED, evidence: phase85v2-evidence-security-api.json:details.endpoint_controls)
- Permissions included in role definitions: cluster_permissions, index_permissions, tenant_permissions (VERIFIED, evidence: phase85v2-evidence-security-api.json:details.roles_enumerated.permissions_included)
