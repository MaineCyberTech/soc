# Phase 85: Live Role Inventory 4

**Report ID:** 153-live-role-inventory-04
**Phase:** 85
**Title:** Live Role Inventory 4
**Date:** 2026-08-31
**Timestamp:** 2026-08-31T22:50:00Z
**Timestamp (ET):** 2026-08-31T18:50:00EDT
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** ops/reports/evidence/phase85/phase85-evidence-rbac-readall.json
**Prompt:** /home/user/mct-p85/prompts/153-live-role-inventory-04.md

---

Authenticated live role enumeration (Security API GET roles) ATTESTS the role set including all_access, readall, readall_and_monitor, kibana_user, kibana_server, logstash, manage_snapshots, manage_wazuh_index, own_index, audit_viewer, and the standard OpenSearch reserved roles. readall = index_patterns ['*'], allowed_actions ['read'], cluster_permissions ['cluster_composite_ops_ro'], reserved/static. audit_viewer is defined (read/search on security-auditlog-* and .opendistro_security) but unmapped. Full enumeration in the referenced evidence. Work item 4 of 10.
