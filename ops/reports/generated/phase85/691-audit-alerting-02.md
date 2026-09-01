---
report_id: 691
phase: 85
title: "Audit Alerting — Phase 83 Monitor Verification"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/691-audit-alerting-02.md
---

## Summary
Phase 83 audit failed-login-spike monitor verified enabled and actively firing.

## Evidence
- **Monitor ID**: WGHXVqABGF64cJf5SH_Y
- **Name**: phase83-failed-login-spike
- **Schedule**: Every 1 minute
- **Indices**: security-auditlog-*
- **Query**: FAILED_LOGIN category + @timestamp range (last 5 minutes)
- **Trigger**: failed-login-spike, severity 2, condition: ctx.results[0].hits.total.value > 200
- **Live state**: ACTIVE, firing continuously since 2026-08-31T08:02:45Z
- **Last notification**: 2026-09-01T00:38:24Z
- **Dry-run test**: 529 hits in 1-min window (threshold 200) → TRIGGERED

## Verification Method
Monitor search API; alerts API; dry-run execution (`POST /_plugins/_alerting/monitors/{id}/_execute?dryrun=true`).

## Finding
**VERIFIED** — Phase 83 monitor enabled and firing continuously. High volume driven by stale admin credential in wazuh-modulesd (~99% of FAILED_LOGIN). Monitor functioning as designed.
