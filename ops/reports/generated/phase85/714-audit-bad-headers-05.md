---
report_id: 714
phase: 85
title: "BAD_HEADERS — Attack Detection Capability"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/714-audit-bad-headers-05.md
---

## Summary
BAD_HEADERS provides detection capability for header spoofing attacks.

## Evidence
- **Detected headers**: _opendistro_security_user, _opendistro_security_remote_address, _opendistro_security_source_field_context, _opendistro_security_roles
- **Attack vector**: Client attempts to inject internal security headers to bypass authentication/authorization
- **Response**: Immediate 500 rejection + audit event
- **Alerting**: No dedicated monitor (would require new monitor on BAD_HEADERS category)

## Verification Method
Documentation review; live test with _opendistro_security_user header.

## Finding
**VERIFIED** — BAD_HEADERS detects and audits header spoofing attempts. Recommended: create dedicated monitor for BAD_HEADERS >0 to alert on spoofing attempts.
