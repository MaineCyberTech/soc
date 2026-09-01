# Phase 85: Readall Removal Plan 3

**Report ID:** 222-readall-removal-plan-03
**Phase:** 85
**Title:** Readall Removal Plan 3
**Date:** 2026-08-31
**Timestamp:** 2026-08-31T22:50:00Z
**Timestamp (ET):** 2026-08-31T18:50:00EDT
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** ops/reports/evidence/phase85/phase85-evidence-rbac-readall.json
**Prompt:** /home/user/mct-p85/prompts/222-readall-removal-plan-03.md

---

Removal plan (candidate, NOT executed): (1) map audit_viewer to the SOC audit identity (read/search on security-auditlog-* + .opendistro_security); (2) (re)provision and map soc_least_priv for SOC operational reads; (3) migrate filebeat/Shuffle to scoped write/read roles; (4) remove the 'readall' backend-role catch-all after convergence; (5) verify with positive scoped + negative overreach tests and a rollback snapshot. Blocked this phase pending approval + verified consumer convergence. Work item 3 of 10.
