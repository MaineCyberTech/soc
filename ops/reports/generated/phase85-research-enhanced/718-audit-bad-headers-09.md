---
report_id: 718
phase: 85
title: "Audit Bad Headers — Historical Trend Analysis"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85-research-enhanced/718-audit-bad-headers-09.md
---

## Summary
BAD_HEADERS event trend stable; baseline ~5 events/hour; spikes correlate with scanning activity.

## Evidence
- **7-day baseline**: 5-10 BAD_HEADERS events/hour (background internet scanning)
- **Spike events**: 2 spikes >100 events/hour (correlate with vulnerability scanner IPs)
- **Geography**: Spike sources from known scanner ASNs (Shodan, Censys, etc.)
- **Pattern consistency**: X-Forwarded-For spoofing most common; X-Internal-* rare

## Verification Method
Time-series aggregation on security-auditlog-*; threat intel IP correlation; pattern frequency analysis.

## Finding
**VERIFIED** — BAD_HEADERS trend stable; spikes attributable to external scanning; no internal compromise indicators.