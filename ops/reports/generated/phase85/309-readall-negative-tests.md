**Report ID:** phase85-309
**Phase:** 85
**Title:** Readall Negative Tests - Test 309
**Date:** 2026-09-01
**Timestamp:** 2026-09-01T04:00:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** ops/reports/generated/phase85/309-readall-negative-tests.md

**Claims:**
- Negative permission tests executed (VERIFIED, evidence: phase85v2-evidence-rbac-readall.json:readall_negative_tests)
- Anonymous GET .opendistro_security/_search -> HTTP 401 (security config denied to unauthenticated) (VERIFIED, evidence: phase85-evidence-rbac-readall.json:negative_tests NEGATIVE 1)
- Anonymous GET wazuh-alerts-4.x-2026.08.18 -> HTTP 401 (data index denied to unauthenticated) (VERIFIED, evidence: phase85-evidence-rbac-readall.json:negative_tests NEGATIVE 2)
- Readall role allows only 'read' action, no write/cluster-admin (VERIFIED, evidence: phase85-evidence-rbac-readall.json:negative_tests NEGATIVE 3)
- all_access confined to admin backend_role, not assigned to non-admin users (VERIFIED, evidence: phase85-evidence-rbac-readall.json:negative_tests NEGATIVE 4)
