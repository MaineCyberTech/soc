# Phase 82: Opensearch Audit 9

## Header
- Report ID: 388
- Phase: 82
- Title: Opensearch Audit 9
- Date: 2026-08-31
- Timestamp UTC: 2026-08-31T06:28:53Z
- Timestamp ET: 2026-08-31T02:28:53 EDT
- Classification: INTERNAL
- Status: PASS
- Source Path: ops/reports/generated/phase82/388-opensearch-audit-09.md
- Prompt: /home/user/mct-p82/prompts/388-opensearch-audit-09.md

## Status
PASS

## Summary
OpenSearch security audit logging is enabled and bounded: failed login, authenticated access, missing privileges and TLS exceptions are all captured in security-auditlog-* without sensitive headers or plaintext request bodies. Retention (ISM, 180d delete) and an alerting monitor on failed-login spikes complete the control.

## Verified properties (all true)
| Property | Value |
|---|---|
| audit_enabled | true |
| failed_login_tested | true |
| authenticated_tested | true |
| missing_privileges_tested | true |
| ssl_exception_tested | true |
| sensitive_headers_disabled | true |
| request_body_disabled_or_redacted | true |
| retention_defined | true |
| access_restricted | true |
| alerting_tested | true |

## Evidence
- Primary evidence: ops/reports/evidence/phase82/phase82-evidence-audit.json
- Live audit index: security-auditlog-2026.08.31 (categories observed: FAILED_LOGIN, AUTHENTICATED, MISSING_PRIVILEGES, SSL_EXCEPTION, GRANTED_PRIVILEGES, COMPLIANCE_*).
- Audit config: exclude_sensitive_headers=true, log_request_body=false, AUTHENTICATED/GRANTED_PRIVILEGES categories enabled.
- Retention: ISM policy 'security-auditlog-retention' attached to audit indices.
- Alerting: monitor 'phase82-audit-failed-login-spike' executes and fires on FAILED_LOGIN events.
- Access: authentication required (anonymous 401); dedicated 'audit_viewer' role; low-privilege query returns 403.
