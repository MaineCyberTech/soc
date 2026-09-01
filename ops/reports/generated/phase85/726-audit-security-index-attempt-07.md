---
report_id: 726
phase: 85
title: "SECURITY_INDEX_ATTEMPT — TLS Admin Certificate Distinction"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/726-audit-security-index-attempt-07.md
---

## Summary
TLS admin certificate distinction verified: admin cert bypasses OPENSEARCH_SECURITY_INDEX_ATTEMPT.

## Evidence
- **Admin TLS cert**: CN=admin,OU=Wazuh,O=Wazuh,L=California,C=US (superadmin)
- **Behavior**: TLS admin cert grants full security index access (HTTP 200)
- **Audit**: No OPENSEARCH_SECURITY_INDEX_ATTEMPT for TLS admin cert actions
- **Basic auth admin**: Internal user 'admin' with basic auth → 403 + OPENSEARCH_SECURITY_INDEX_ATTEMPT

## Verification Method
Phase 85 snapshot negative tests S1/S2 (admin TLS cert vs internal user admin); live test with basic auth admin.

## Finding
**VERIFIED** — TLS admin certificate (superadmin) correctly exempt from OPENSEARCH_SECURITY_INDEX_ATTEMPT. Only non-superadmin identities trigger the category. Proper authorization boundary enforced.
