**Report ID:** phase85-273
**Phase:** 85
**Title:** Readall Removal Plan - Plan 273
**Date:** 2026-09-01
**Timestamp:** 2026-09-01T04:00:00Z
**Classification:** INTERNAL
**Status:** PLAN-ONLY
**Source Path:** ops/reports/generated/phase85/273-readall-removal-plan.md

**Claims:**
- Readall removal plan documented but NOT executed this phase (VERIFIED, evidence: phase85v2-evidence-rbac-readall.json:readall_removal_plan)
- No cutover/removal mutation performed; Phase 85 is read-only enumeration + retention decision (VERIFIED, evidence: phase85-evidence-rbac-readall.json:cutover_approval_or_blocker)
- Removal requires: operator approval, rollback path, verified consumer convergence (NOT granted this phase) (VERIFIED, evidence: phase85-evidence-rbac-readall.json:cutover_approval_or_blocker)
- Readall retained as bounded exception (VERIFIED, evidence: phase85v2-evidence-rbac-readall.json:old_mapping_removed_or_exception)
