# Phase 85: Readall Negative Tests 1

**Report ID:** 250-readall-negative-tests-01
**Phase:** 85
**Title:** Readall Negative Tests 1
**Date:** 2026-08-31
**Timestamp:** 2026-08-31T22:50:00Z
**Timestamp (ET):** 2026-08-31T18:50:00EDT
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** ops/reports/evidence/phase85/phase85-evidence-rbac-readall.json
**Prompt:** /home/user/mct-p85/prompts/250-readall-negative-tests-01.md

---

Negative authorization tests (read-only, no secrets): anonymous GET on .opendistro_security -> HTTP 401 (security index denied to unauthenticated); anonymous GET on wazuh-alerts-4.x-2026.08.18 -> HTTP 401 (data index denied to unauthenticated); readall role exposes allowed_actions=['read'] ONLY, so write and cluster-admin are denied by design; all_access is bound to backend_role ['admin'] and not assigned to any non-admin internal user. All denials confirmed. Work item 1 of 10.
