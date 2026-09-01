---
report_id: 767
phase: 85
title: "Audit Old Credential Use — Cross-Reference with Other Categories"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85-research-enhanced/767-audit-old-credential-use-08.md
---

## Summary
Old credential attempts only appear in FAILED_LOGIN; no SSL_EXCEPTION, BAD_HEADERS, or security-index correlation.

## Evidence
- **FAILED_LOGIN**: 85,000+ events for user='admin'
- **SSL_EXCEPTION**: 0 events from same source IPs (TLS handshake succeeds)
- **BAD_HEADERS**: 0 events from same source IPs (standard headers)
- **OPENSEARCH_SECURITY_INDEX_ATTEMPT**: 0 events (attackers only try auth, not config)
- **Conclusion**: Pure credential stuffing; no exploit chaining observed

## Verification Method
Source IP cross-correlation across all audit categories; attack chain analysis.

## Finding
**VERIFIED** — Attack isolated to credential stuffing; no lateral exploit attempts detected via audit.