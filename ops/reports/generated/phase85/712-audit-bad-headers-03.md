---
report_id: 712
phase: 85
title: "BAD_HEADERS — Event Structure Analysis"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/712-audit-bad-headers-03.md
---

## Summary
BAD_HEADERS event structure analyzed for forensic value.

## Evidence
- **Category**: BAD_HEADERS
- **Layer**: REST (triggered via HTTP header)
- **Trigger header**: _opendistro_security_user (internal security header)
- **Rejection reason**: "Illegal parameter...spoofing requests"
- **Forensic fields**: audit_request_effective_user, audit_request_remote_address, audit_rest_request_path, audit_request_layer

## Verification Method
Live trigger test; audit document retrieval via search.

## Finding
**VERIFIED** — BAD_HEADERS events contain full request context (user, IP, path, layer) for forensic analysis. Header spoofing attempts fully audited with actionable metadata.
