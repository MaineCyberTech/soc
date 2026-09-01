**Report ID:** phase85-218
**Phase:** 85
**Title:** Reserved Hidden Resources - Resource 218
**Date:** 2026-09-01
**Timestamp:** 2026-09-01T04:00:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** ops/reports/generated/phase85/218-reserved-hidden-resources.md

**Claims:**
- Reserved/static roles cataloged in live enumeration (VERIFIED, evidence: phase85v2-evidence-rbac-readall.json:reserved_resources_cataloged)
- Reserved roles: all_access, kibana_server, kibana_user, logstash, manage_snapshots, manage_wazuh_index, own_index, readall, readall_and_monitor (static: true, reserved: true) (VERIFIED, evidence: live-rbac-snapshot.json:roles)
- Hidden roles: none marked hidden in live roles (VERIFIED, evidence: live-rbac-snapshot.json:roles)
- Security config index .opendistro_security protected (VERIFIED, evidence: live-rbac-snapshot.json:roles.audit_viewer.index_permissions[1].index_patterns)
