# Phase 53: Direct Bearer Auth

**Prompt:** 081-direct-auth
**Generated (UTC):** 2026-08-27T20:08:15Z
**Operator (EDT):** 2026-08-27T16:08:15-0400
**Verdict:** DONE

## Summary
Verified Shuffle backend bearer auth on the REST API: a valid bearer token returns 200, while a missing or invalid token returns 401 (fail-closed). No mutation performed; read-only test only.

## Evidence
- E3: `curl GET /api/v1/workflows` WITH valid SHUFFLE_API_KEY (referenced by path /opt/mct-security-stack/.env) -> http_status=200.
- E3: SAME endpoint WITHOUT Authorization header -> http_status=401.
- E3: SAME endpoint WITH invalid literal token `invalid_token_xyz` -> http_status=401 (confirms fail-closed, no token echo).

## Backup / Rollback
N/A (read-only auth test).

## Stop conditions
None.

## Limitations
Test exercised the Shuffle backend API (127.0.0.1:5001); IRIS-side bearer behavior is covered separately via the live ROUTED proof (prompt 095-100).

## Verdict rationale
Direct bearer auth behaves as required: 200 with token, 401 without.
