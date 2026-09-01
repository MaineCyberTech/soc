**Report ID:** phase85-360
**Phase:** 85
**Title:** RBAC Drift Monitor - Monitor 360
**Date:** 2026-09-01
**Timestamp:** 2026-09-01T04:00:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** ops/reports/generated/phase85/360-rbac-drift-monitor.md

**Claims:**
- RBAC drift monitor operational (VERIFIED, evidence: phase85v2-evidence-rbac-readall.json:rbac_drift_monitor)
- Daily read-only re-snapshot: GET internalusers/roles/rolesmapping via Security API (VERIFIED, evidence: phase85-evidence-rbac-readall.json:drift_monitor)
- Recomputes live snapshot sha256, diffs against baseline 7bc3d6bdb4b7451e578710c5e1f636ac570775da09b3b24bb2188a79333075da (VERIFIED, evidence: phase85-evidence-rbac-readall.json:drift_monitor, live_baseline_sha256)
- Triggers on: readall mapping change, audit_viewer mapping change, new wildcard ('*') index grants (VERIFIED, evidence: phase85-evidence-rbac-readall.json:drift_monitor)
- Operator alert (paged to SOC) + written drift event in ops/backups/rbac/<date> (VERIFIED, evidence: phase85-evidence-rbac-readall.json:drift_monitor)
- CI gate fails if live sha256 diverges without recorded disposition (VERIFIED, evidence: phase85-evidence-rbac-readall.json:drift_monitor)
- Snapshots stored with date-stamped sha256 under ops/backups/rbac/ (VERIFIED, evidence: phase85-evidence-rbac-readall.json:drift_monitor)
