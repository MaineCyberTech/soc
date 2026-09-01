---
report_id: 762
phase: 85
title: "Audit Old Credential Use — Alert Trigger Verification"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85-research-enhanced/762-audit-old-credential-use-03.md
---

## Summary
Failed login spike monitors (phase82/phase83) continuously firing due to old credential attack volume.

## Evidence
- **Monitor threshold**: >200 FAILED_LOGIN events/minute
- **Actual rate**: 200-300 events/minute sustained
- **Alert state**: Both monitors FIRING continuously since rotation
- **Deduplication**: 15-min window prevents notification spam; single ongoing alert
- **Alert payload**: Includes sample events, rate, top source IPs

## Verification Method
Monitor status check; trigger history review; alert payload validation; deduplication confirmation.

## Finding
**VERIFIED** — Spike monitors effectively detecting old credential attack volume; alerting operational.