# Phase 82: Auth Monitoring 1

## Header
- Report ID: 370
- Phase: 82
- Title: Auth Monitoring 1
- Date: 2026-08-31
- Timestamp UTC: 2026-08-31T06:28:53Z
- Timestamp ET: 2026-08-31T02:28:53 EDT
- Classification: INTERNAL
- Status: PASS
- Source Path: ops/reports/generated/phase82/370-auth-monitoring-01.md
- Prompt: /home/user/mct-p82/prompts/370-auth-monitoring-01.md

## Status
PASS

## Summary
Authentication signal monitoring: the OpenSearch audit stream now provides both FAILED_LOGIN and AUTHENTICATED events, feeding detection of brute-force / credential-attack and of legitimate vs anomalous access. The failed-login-spike alerting monitor converts these signals into actionable alerts.

## Monitored signals
- FAILED_LOGIN: captured in security-auditlog-* (audit_category=FAILED_LOGIN). Verified count > 0 after a deliberate bad-password attempt (HTTP 401).
- AUTHENTICATED: captured after enabling the AUTHENTICATED category (audit_category=AUTHENTICATED, count > 0).
- MISSING_PRIVILEGES: captured on authorization-denied requests (audit_category=MISSING_PRIVILEGES).
- SSL_EXCEPTION: captured on TLS handshake failures (audit_category=SSL_EXCEPTION).

## Alerting on signals
- Monitor 'phase82-audit-failed-login-spike' (query_level_monitor over security-auditlog-*) executes and its 'failed-login-spike' trigger evaluates triggered:true, proving the signal is wired to alerting.

## Evidence
- Primary evidence: ops/reports/evidence/phase82/phase82-evidence-audit.json
- Source audit index: security-auditlog-2026.08.31.
