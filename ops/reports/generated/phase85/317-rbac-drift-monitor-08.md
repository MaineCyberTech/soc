# Phase 85: RBAC Drift Monitor 8

**Report ID:** 317-rbac-drift-monitor-08
**Phase:** 85
**Title:** RBAC Drift Monitor 8
**Date:** 2026-08-31
**Timestamp:** 2026-08-31T22:50:00Z
**Timestamp (ET):** 2026-08-31T18:50:00EDT
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** ops/reports/evidence/phase85/phase85-evidence-rbac-readall.json
**Prompt:** /home/user/mct-p85/prompts/317-rbac-drift-monitor-08.md

---

Drift is monitored going forward by a daily read-only re-snapshot of internalusers/roles/rolesmapping via the same authenticated Security API method, recomputing the live snapshot sha256 and diffing against baseline 7bc3d6bdb4b7451e578710c5e1f636ac570775da09b3b24bb2188a79333075da. Any change to the readall mapping, audit_viewer mapping, or any new wildcard ('*') index grant raises a SOC alert and a dated drift event under ops/backups/rbac/. A CI gate fails on undocumented divergence. The monitor hard-flags expiry at 2026-09-30 to block silent extension. Work item 8 of 10.
