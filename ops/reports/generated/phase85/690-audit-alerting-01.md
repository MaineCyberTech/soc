---
report_id: 690
phase: 85
title: "Audit Alerting — Phase 82 Monitor Verification"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/690-audit-alerting-01.md
---

## Summary
Phase 82 audit failed-login-spike monitor verified enabled and operational.

## Evidence
- **Monitor ID**: sGB_VqABGF64cJf5leMA
- **Name**: phase82-audit-failed-login-spike
- **Schedule**: Every 5 minutes
- **Indices**: security-auditlog-*
- **Query**: Term query for audit_category.keyword=FAILED_LOGIN
- **Trigger**: failed-login-spike, severity 1, condition: ctx.results[0].hits.total.value > 0
- **Actions**: None configured (alert-only)

## Verification Method
`GET /_plugins/_alerting/monitors/_search` filtered for phase82-audit-failed-login-spike.

## Finding
**VERIFIED** — Phase 82 monitor enabled, broad baseline coverage (triggers on any FAILED_LOGIN). Defence-in-depth layer.
