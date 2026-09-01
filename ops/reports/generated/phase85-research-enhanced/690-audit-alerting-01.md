---
report_id: 690
phase: 85
title: "Audit Alerting — Failed Login Spike Monitor Verification"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85-research-enhanced/690-audit-alerting-01.md
---

## Summary
phase83-failed-login-spike monitor confirmed active and firing; threshold >200 events/minute.

## Evidence
- **Monitor ID**: phase83-failed-login-spike (OpenSearch Alerting)
- **Schedule**: Every 1 minute; looks back 1 minute
- **Trigger**: FAILED_LOGIN count > 200 in 1-minute window
- **Live status**: Monitor currently FIRING (continuous failed login attempts on rotated 'admin' credential)
- **Alert actions**: Notification channel configured (Shuffle webhook)

## Verification Method
OpenSearch Alerting UI/API inspection; live trigger history review; alert action delivery confirmation.

## Finding
**VERIFIED** — Failed login spike monitor operational and actively alerting on credential stuffing.