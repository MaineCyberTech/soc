# Phase 85: Readall Current Scope 9

**Report ID:** 208-readall-current-scope-09
**Phase:** 85
**Title:** Readall Current Scope 9
**Date:** 2026-08-31
**Timestamp:** 2026-08-31T22:50:00Z
**Timestamp (ET):** 2026-08-31T18:50:00EDT
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** ops/reports/evidence/phase85/phase85-evidence-rbac-readall.json
**Prompt:** /home/user/mct-p85/prompts/208-readall-current-scope-09.md

---

Current live scope of readall: role index_patterns ['*'], allowed_actions ['read'], cluster_permissions ['cluster_composite_ops_ro'] (read-only, reserved/static). Mapping binds backend_role 'readall'. Holders: internal user 'readall' (backend_roles:['readall']) and 'kibanaro' (backend_roles:['kibanauser','readall']). Effective indexes: ALL indices readable, including security-auditlog-*, wazuh-*, ss4o_*, and .opendistro_security. No write/cluster-admin capability. Work item 9 of 10.
