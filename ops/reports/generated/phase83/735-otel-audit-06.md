# Phase 83: Otel Audit 06

## Header
- Report ID: 735-otel-audit-06.md
- Phase: 83
- Title: Otel Audit 06
- Date: 2026-08-31
- Timestamp UTC: 2026-08-31T08:09:31Z
- Timestamp ET: 2026-08-31T04:09:31 EDT
- Classification: INTERNAL
- Status: PASS
- Source Path: ops/reports/generated/phase83/735-otel-audit-06.md
- Prompt: /home/user/mct-p83/prompts/735-otel-audit-06.md

## Summary
The OTel collector authenticates to OpenSearch under the scoped, least-privilege identity 'otel_collector' (role otel_writer) and its authentication is captured by the OpenSearch security audit log (AUTHENTICATED/GRANTED_PRIVILEGES categories, which are enabled per ops/reports/evidence/phase83/phase83-evidence-audit.json). The same header/body redaction controls apply: Authorization headers, cookies, and request bodies are excluded from audit records for OTel and all other identities. Audit access is restricted to the dedicated audit_viewer role (anon 401, low-priv 403). VERIFIED by ops/reports/evidence/phase83/phase83-evidence-audit.json (authenticated, new_credential_success, authorization_headers_absent, cookies_absent, sensitive_bodies_absent, access_restricted all true).

## Evidence
All 14 audit properties are verified true in ops/reports/evidence/phase83/phase83-evidence-audit.json (audit_enabled, failed_login, authenticated, missing_privileges, ssl_exception, old_credential_failure, new_credential_success, authorization_headers_absent, cookies_absent, sensitive_bodies_absent, retention, access_restricted, monitor_alert, capacity_guard). This report PASSes and references that consolidated evidence.

## Status
PASS
