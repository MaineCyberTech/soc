# Phase 85: RBAC Baseline Diff 6

**Report ID:** 195-rbac-baseline-diff-06
**Phase:** 85
**Title:** RBAC Baseline Diff 6
**Date:** 2026-08-31
**Timestamp:** 2026-08-31T22:50:00Z
**Timestamp (ET):** 2026-08-31T18:50:00EDT
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** ops/reports/evidence/phase85/phase85-evidence-rbac-readall.json
**Prompt:** /home/user/mct-p85/prompts/195-rbac-baseline-diff-06.md

---

Authenticated live RBAC enumeration (Security API GET internalusers/roles/rolesmapping) was diffed against the persisted Phase 84 baseline snapshot (persisted_baseline_sha256 04ccb990e16d327193324103441510e65bfacdea13340ed5a8c3121e860155f7). Live snapshot sha256 7bc3d6bdb4b7451e578710c5e1f636ac570775da09b3b24bb2188a79333075da. Six differences were found and EVERY one is dispositioned (all_differences_dispositioned=true): (1) readall mapping is backend_roles:['readall'] live, not the explicit user-only mapping Phase 84 reported; (2) kibanaro also carries backend_role 'readall'; (3) a dangling p83_lowpriv_role mapping targets a nonexistent role/user; (4) audit_viewer is defined but unmapped; (5) live has 6 internal users vs 8 in Phase 84 (dedup_writer/otel_collector absent as internal users); (6) readall role definition unchanged (index_patterns ['*'], allowed_actions ['read']). None of the differences change the retention decision; full detail in the referenced evidence. Work item 6 of 10.
