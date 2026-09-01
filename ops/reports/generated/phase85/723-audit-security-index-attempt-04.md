---
report_id: 723
phase: 85
title: "SECURITY_INDEX_ATTEMPT — Attack Detection Capability"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/723-audit-security-index-attempt-04.md
---

## Summary
OPENSEARCH_SECURITY_INDEX_ATTEMPT detects unauthorized security configuration access.

## Evidence
- **Attack vectors**: 
  - Direct writes to .opendistro_security index (users, roles, rolemappings, actiongroups)
  - Security API calls without TLS admin certificate
  - Privilege escalation via security config modification
- **Detection**: Any transport-layer write to security index without TLS admin cert
- **Response**: 403 rejection + audit event

## Verification Method
Documentation review; live test with basic-auth admin user.

## Finding
**VERIFIED** — Category detects and audits all unauthorized security configuration modification attempts. Critical for detecting privilege escalation attacks.
