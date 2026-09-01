# Phase 85: Live Role Mapping 8

**Report ID:** 167-live-role-mapping-08
**Phase:** 85
**Title:** Live Role Mapping 8
**Date:** 2026-08-31
**Timestamp:** 2026-08-31T22:50:00Z
**Timestamp (ET):** 2026-08-31T18:50:00EDT
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** ops/reports/evidence/phase85/phase85-evidence-rbac-readall.json
**Prompt:** /home/user/mct-p85/prompts/167-live-role-mapping-08.md

---

Authenticated live rolesmapping enumeration (Security API GET rolesmapping) ATTESTS the live bindings. KEY FINDING: readall maps via backend_roles ['readall'] (catch-all STILL PRESENT), contradicting Phase 84's claim of reduction to explicit user-only. all_access maps via backend_roles ['admin']; kibana_user via ['kibanauser']; logstash via ['logstash']; manage_snapshots via ['snapshotrestore']; a dangling 'p83_lowpriv_role' maps to nonexistent user 'p83_lowpriv'. Full mapping in evidence. Work item 8 of 10.
