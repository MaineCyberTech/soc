# Phase 40-28: TLS Authorized-Path Test (AUTHZ-40-02)

**Report ID:** phase40-28-tls-authorized-test
**Phase:** 40
**Title:** Phase 40-28: Shuffle TLS Authorized-Path Verification — UI, Authenticated API, Workflows
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:00:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-28-tls-authorized-test.md`

---

Test ID AUTHZ-40-02, executed 2026-08-26T01:59Z against the live closure.

## 1. Results

| # | Check | Command shape | Result | Verdict |
|---|-------|---------------|--------|---------|
| 1 | UI over TLS | `curl -sk -o /dev/null -w '%{http_code} %{time_total}' https://192.168.222.149:3443/` | `http=200 time=0.006948s` | PASS [VERIFIED] |
| 2 | Response security headers | `curl -skI https://192.168.222.149:3443/` | `Strict-Transport-Security: max-age=31536000`, `X-Frame-Options` (DENY upstream + SAMEORIGIN proxy), `X-Content-Type-Options: nosniff`, `HTTP/1.1 200 OK` | PASS [VERIFIED] |
| 3 | Authenticated API over TLS | `GET /api/v1/workflows` with rotated bearer (token read from `config/shuffle-api-key`, value never printed) via https://192.168.222.149:3443 | `api_http=200` | PASS [VERIFIED] |
| 4 | Workflow listing content | JSON parse of same response | `workflow_count= 2` — `wazuh-high-severity-to-iris`, `wazuh-flow-classb-to-iris` | PASS [VERIFIED] |

## 2. Bounded Execution Evidence

Workflow executions were running during this phase (webhook-triggered ingest exercised
in the field-fix arc, phase40-08/-09); the authenticated API path above returns live
workflow state over TLS, confirming end-to-end function of the protected channel, not
merely a static page.

## 3. No Insecure Fallback

No insecure fallback path was used or needed for authorized access:

- A browser pointed at `https://192.168.222.149:3443` reaches the UI directly
  (self-signed warning → accept once; see TOFU note in phase40-31).
- Loopback HTTP (`127.0.0.1:3001`, verified `http=200`) exists solely as the
  SSH-tunnel emergency recovery lane and is unreachable from LAN interfaces.

## 4. Verdict

**PASS.** Protected transport serves the full authorized operator workflow
(login UI + bearer-authenticated API) with security headers present.

Cross-refs: implementation phase40-27 · blocked-path counterpart phase40-29.
