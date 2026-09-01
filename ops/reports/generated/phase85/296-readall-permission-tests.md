**Report ID:** phase85-296
**Phase:** 85
**Title:** Readall Permission Tests - Test 296
**Date:** 2026-09-01
**Timestamp:** 2026-09-01T04:00:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** ops/reports/generated/phase85/296-readall-permission-tests.md

**Claims:**
- Authenticated positive permission tests executed (VERIFIED, evidence: phase85v2-evidence-rbac-readall.json:readall_permission_tests)
- Admin identity (all_access via backend_role 'admin') GET wazuh-alerts-4.x-2026.08.18/_search -> HTTP 200, hits 10000 (VERIFIED, evidence: phase85-evidence-rbac-readall.json:positive_tests)
- Authorized identity can read authorized index through live Security config (VERIFIED, evidence: phase85-evidence-rbac-readall.json:positive_tests)
- No secrets printed, logged, or transmitted in any test (VERIFIED, evidence: phase85-evidence-rbac-readall.json:negative_tests)
