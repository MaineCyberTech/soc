# Phase 56: Auth Mode

**Prompt:** 223-os-auth
**Generated (UTC):** 2026-08-28T00:30:00Z
**Operator (EDT):** 2026-08-27T20:30:00-0400
**Verdict:** DONE

## Summary
Determined the authentication mode of the Shuffle OpenSearch datastore (value-blind; no secret values read or printed).

## Evidence
- EV-OS-AUTH-1 (VERIFIED): `GET /` on `172.20.0.8:9200` returns HTTP 200 with no `Authorization` header and no credentials — anonymous access is permitted.
- EV-OS-AUTH-2 (PARTIAL): `GET /_plugins/_security/api/status` returns `no handler found for uri ... and method [GET]` — the security management REST API is not registered, indicating the security plugin is **disabled** in this cluster. The `.opendistro_security` and `security-auditlog-*` indices exist (plugin artifacts present) but auth enforcement is off.
- EV-OS-AUTH-3 (VERIFIED, SEPARATE — Wazuh cluster): The Wazuh indexer at `127.0.0.1:9200` DOES require auth (`https` → 401); that is a different cluster with its own credential model (referenced by path `config/.../creds.env`, never read/printed here).

## Backup/Rollback
Read-only; no changes.

## Stop conditions
None. Enabling/auth-configuring the Shuffle OS security plugin is an exposure/auth gate and was NOT taken.

## Limitations
Value-blind by design: no secret/token values were read or printed. Confirmation that security is fully disabled rests on absence of the management handler; a deeper config-file read would require container/file access beyond read-only API scope.

## Verdict rationale
Auth mode established: Shuffle OpenSearch datastore runs with security disabled / anonymous open; the Wazuh indexer (separate) requires auth. DONE.
