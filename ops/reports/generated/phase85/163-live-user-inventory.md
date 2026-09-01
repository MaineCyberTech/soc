**Report ID:** phase85-163
**Phase:** 85
**Title:** Live User Inventory - User 163
**Date:** 2026-09-01
**Timestamp:** 2026-09-01T04:00:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** ops/reports/generated/phase85/163-live-user-inventory.md

**Claims:**
- Live internal_users enumeration complete via Security API GET /_plugins/_security/api/internalusers (VERIFIED, evidence: phase85v2-evidence-rbac-readall.json:user_inventory_complete)
- 6 identities captured: admin, kibanaserver, kibanaro, logstash, readall, snapshotrestore (VERIFIED, evidence: live-rbac-snapshot.json:internal_users)
- No dedup_writer or otel_collector internal users present live (VERIFIED, evidence: phase85-evidence-rbac-readall.json:semantic_diff point 5)
- Password hashes and secret-derived material omitted per secret handling policy (VERIFIED, evidence: live-rbac-snapshot.json:secret_handling)
