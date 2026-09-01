# Phase 85: Readall Exception Close 6

**Report ID:** 295-readall-exception-close-06
**Phase:** 85
**Title:** Readall Exception Close 6
**Date:** 2026-08-31
**Timestamp:** 2026-08-31T22:50:00Z
**Timestamp (ET):** 2026-08-31T18:50:00EDT
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** ops/reports/evidence/phase85/phase85-evidence-rbac-readall.json
**Prompt:** /home/user/mct-p85/prompts/295-readall-exception-close-06.md

---

The readall exception is explicitly RETAINED as a BOUNDED exception through 2026-09-30 (NOT closed/removed this phase). Owner: soc@mainecybertech.com. Compensating controls: readall is read-only by design (allowed_actions=['read']); audit_viewer role (read/search on security-auditlog-* and .opendistro_security) is predefined as the audit-separation identity to be mapped before expiry; soc_least_priv is to be (re)provisioned for SOC reads; the daily sha256 drift monitor detects any change to the readall mapping or new wildcard grants. There is NO silent extension beyond 2026-09-30. Work item 6 of 10.
