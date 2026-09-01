# Phase 85: Readall Permission Tests 7

**Report ID:** 246-readall-permission-tests-07
**Phase:** 85
**Title:** Readall Permission Tests 7
**Date:** 2026-08-31
**Timestamp:** 2026-08-31T22:50:00Z
**Timestamp (ET):** 2026-08-31T18:50:00EDT
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** ops/reports/evidence/phase85/phase85-evidence-rbac-readall.json
**Prompt:** /home/user/mct-p85/prompts/246-readall-permission-tests-07.md

---

Permission tests: POSITIVE — admin (authorized, all_access via backend_role 'admin') GET wazuh-alerts-4.x-2026.08.18/_search?size=1 -> HTTP 200, hits 10000 (allowed read succeeds). NEGATIVE — anonymous access to .opendistro_security and to data indexes returned HTTP 401 (denied). readall holders are limited to read by role definition. No secret value was handled in any test. Work item 7 of 10.
