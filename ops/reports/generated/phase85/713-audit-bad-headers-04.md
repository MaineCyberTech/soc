---
report_id: 713
phase: 85
title: "BAD_HEADERS — Transport Layer Coverage"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/713-audit-bad-headers-04.md
---

## Summary
BAD_HEADERS transport layer coverage verified via configuration.

## Evidence
- **Config**: disabled_transport_categories does NOT include BAD_HEADERS (only AUTHENTICATED, GRANTED_PRIVILEGES)
- **Documentation**: BAD_HEADERS listed as "Logged on REST: Yes, Logged on Transport: Yes"
- **Transport headers**: audit_transport_headers field captures internal security headers on transport layer

## Verification Method
Live config inspection; OpenSearch Security documentation cross-reference.

## Finding
**VERIFIED** — BAD_HEADERS enabled on transport layer. Inter-node spoofing attempts via internal headers would be captured. No live transport test executed (requires inter-node traffic injection).
